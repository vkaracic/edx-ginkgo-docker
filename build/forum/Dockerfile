FROM karacic/xenial-base:ginkgo.master

RUN sudo rm -rf /edx/app/edx_ansible/edx_ansible
RUN git clone --depth 1 --branch open-release/ginkgo.master https://github.com/edx/configuration.git /edx/app/edx_ansible/edx_ansible

WORKDIR /edx/app/edx_ansible/edx_ansible/docker/plays
COPY ansible_overrides.yml /

ARG container_prefix
ARG OPENEDX_RELEASE=open-release/ginkgo.master
ENV OPENEDX_RELEASE=${OPENEDX_RELEASE}
RUN /edx/app/edx_ansible/venvs/edx_ansible/bin/ansible-playbook forum.yml \
    -i '127.0.0.1,' -c local \
    -t "install:base,install:configuration,install:app-requirements,install:code" \
    --extra-vars=container_prefix=${container_prefix} \
    --extra-vars="forum_version=${OPENEDX_RELEASE}" \
    --extra-vars="@/ansible_overrides.yml"

WORKDIR /edx/app
CMD ["/edx/app/supervisor/venvs/supervisor/bin/supervisord", "-n", "--configuration", "/edx/app/supervisor/supervisord.conf"]
EXPOSE 4567
