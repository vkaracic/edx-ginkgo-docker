FROM vkaracic/xenial-base:ginkgo.1
USER root
CMD ["/edx/app/supervisor/venvs/supervisor/bin/supervisord", "-n", "--configuration", "/edx/app/supervisor/supervisord.conf"]

RUN sudo rm -rf /edx/app/edx_ansible/edx_ansible
RUN git clone --depth 1 --branch open-release/ginkgo.1 https://github.com/edx/configuration.git /edx/app/edx_ansible/edx_ansible
WORKDIR /edx/app/edx_ansible/edx_ansible/docker/plays

COPY ansible_overrides.yml /
COPY devstack.yml /
COPY devstack-ansible_overrides.yml /devstack/ansible_overrides.yml

ARG OPENEDX_RELEASE=master
ENV OPENEDX_RELEASE=${OPENEDX_RELEASE}
RUN sudo /edx/app/edx_ansible/venvs/edx_ansible/bin/ansible-playbook edxapp.yml \
    -c local -i '127.0.0.1,' \
    -t 'install,assets,devstack' \
    --extra-vars=edx_platform_version=${OPENEDX_RELEASE} \
    --extra-vars="@/ansible_overrides.yml" \
    --extra-vars="@/devstack.yml" \
    --extra-vars="@/devstack/ansible_overrides.yml"

EXPOSE 18000 18010
