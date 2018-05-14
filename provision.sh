#!/usr/bin/env bash

set -e
set -o pipefail
set -x


GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo -e "${GREEN}Creating .env file...${NC}"
cat > .env << EOF
CONTAINER_PREFIX=${CONTAINER_PREFIX}
EOF

# Bring the databases online.
docker-compose up -d mysql mongo

# Ensure the MySQL server is online and usable
echo "Waiting for MySQL"
until docker exec -i ${CONTAINER_PREFIX}.mysql mysql -uroot -se "SELECT EXISTS(SELECT 1 FROM mysql.user WHERE user = 'root')" &> /dev/null
do
  printf "."
  sleep 1
done

# In the event of a fresh MySQL container, wait a few seconds for the server to restart
# This can be removed once https://github.com/docker-library/mysql/issues/245 is resolved.
sleep 20

echo -e "MySQL ready"

echo -e "${GREEN}Creating databases and users...${NC}"
docker exec -i ${CONTAINER_PREFIX}.mysql mysql -uroot mysql < data/provision.sql
docker exec -i ${CONTAINER_PREFIX}.mongo mongo < data/mongo-provision.js

# Load databases
echo -e "${GREEN}Loading databases...${NC}"
docker exec -i ${CONTAINER_PREFIX}.mysql mysql -uroot edxapp < data/edxapp.sql
docker exec -i ${CONTAINER_PREFIX}.mysql mysql -uroot edxapp_csmh < data/edxapp_csmh.sql

# Bring edxapp containers online
echo -e "${GREEN}Bringing containers online${NC}"
docker-compose -f docker-compose.yml -f docker-compose-host.yml up -d lms
docker-compose -f docker-compose.yml -f docker-compose-host.yml up -d studio

echo -e "${GREEN}Installing prereqs ${NC}"
docker-compose exec lms bash -c 'source /edx/app/edxapp/edxapp_env && cd /edx/app/edxapp/edx-platform && NO_PYTHON_UNINSTALL=1 paver install_prereqs'
docker-compose exec studio bash -c 'source /edx/app/edxapp/edxapp_env && cd /edx/app/edxapp/edx-platform && NO_PYTHON_UNINSTALL=1 paver install_prereqs'

# Installing prereqs crashes the process
echo -e "${GREEN}Restarting LMS Studio${NC}"
docker-compose restart lms studio

echo -e "${GREEN} Run edxapp migrations first since they are needed for the service users and OAuth clients ${NC}"
docker-compose exec lms bash -c 'source /edx/app/edxapp/edxapp_env && cd /edx/app/edxapp/edx-platform && paver update_db --settings devstack_docker'
docker-compose exec studio bash -c 'source /edx/app/edxapp/edxapp_env && cd /edx/app/edxapp/edx-platform && paver update_db --settings devstack_docker'

echo -e "${GREEN} Create a superuser for edxapp ${NC}"
docker-compose exec lms bash -c 'source /edx/app/edxapp/edxapp_env && python /edx/app/edxapp/edx-platform/manage.py lms --settings=devstack_docker manage_user edx edx@example.com --superuser --staff'
docker-compose exec lms bash -c 'source /edx/app/edxapp/edxapp_env && echo "from django.contrib.auth import get_user_model; User = get_user_model(); user = User.objects.get(username=\"edx\"); user.set_password(\"edx\"); user.save()" | python /edx/app/edxapp/edx-platform/manage.py lms shell  --settings=devstack_docker'

echo -e "${GREEN} Create demo course and users ${NC}"
docker-compose exec lms bash -c '/edx/app/edx_ansible/venvs/edx_ansible/bin/ansible-playbook /edx/app/edx_ansible/edx_ansible/playbooks/edx-east/demo.yml -v -c local -i "127.0.0.1," --extra-vars="COMMON_EDXAPP_SETTINGS=devstack_docker"'

docker-compose exec lms bash -c 'source /edx/app/edxapp/edxapp_env && cd /edx/app/edxapp/edx-platform && paver update_assets --settings devstack_docker'
docker-compose exec studio bash -c 'source /edx/app/edxapp/edxapp_env && cd /edx/app/edxapp/edx-platform && paver update_assets --settings devstack_docker'

echo -e "${GREEN}FINISHED !!!${NC}"

docker-compose -f docker-compose.yml -f docker-compose-host.yml up -d studio

