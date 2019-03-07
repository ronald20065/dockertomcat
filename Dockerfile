FROM ubuntu:16.04
LABEL maintainer="Prasad Ronald"

ENV pip_packages "ansible pyopenssl"

# Install dependencies.
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       python-software-properties \
       software-properties-common \
       python-setuptools \
       python-pip \
       vim \
       net-tools \
       curl \
       rsyslog systemd systemd-cron sudo \
    && rm -Rf /var/lib/apt/lists/* \
    && rm -Rf /usr/share/doc && rm -Rf /usr/share/man \
    && apt-get clean
RUN sed -i 's/^\($ModLoad imklog\)/#\1/' /etc/rsyslog.conf

# Install Ansible via Pip.
RUN pip install $pip_packages

#COPY initctl_faker .
#RUN chmod +x initctl_faker && rm -fr /sbin/initctl && ln -s /initctl_faker /sbin/initctl

# Install Ansible inventory file.
RUN mkdir -p /etc/ansible
RUN echo "[local]\nlocalhost ansible_connection=local" > /etc/ansible/hosts

RUN set -x && \
    \
    echo "==> Create directory"  && \
    mkdir -p /etc/ansible \
    \
    echo "==> Install Ansible inventory file"  && \
    echo "[local]\nlocalhost ansible_connection=local" > /etc/ansible/hosts

#VOLUME ["/sys/fs/cgroup", "/tmp", "/run"]
#CMD ["/lib/systemd/systemd"]

ENV ANSIBLE_GATHERING smart
ENV ANSIBLE_HOST_KEY_CHECKING false
ENV ANSIBLE_RETRY_FILES_ENABLED false
ENV ANSIBLE_ROLES_PATH /ansible/playbooks/roles
ENV ANSIBLE_SSH_PIPELINING True
#ENV PYTHONPATH /ansible/lib
ENV PATH /ansible/bin:$PATH
#ENV ANSIBLE_LIBRARY /ansible/library

WORKDIR /ansible/playbooks

#ENTRYPOINT ["ansible-playbook"]
VOLUME ["/sys/fs/cgroup", "/tmp", "/run"]
CMD ["/lib/systemd/systemd"]
