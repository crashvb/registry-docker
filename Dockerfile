FROM registry:2.7.1@sha256:36cb5b157911061fb610d8884dc09e0b0300a767a350563cbfd88b4b85324ce4
ARG org_opencontainers_image_created=undefined
ARG org_opencontainers_image_revision=undefined
LABEL \
	org.opencontainers.image.authors="Richard Davis <crashvb@gmail.com>" \
	org.opencontainers.image.base.digest="sha256:36cb5b157911061fb610d8884dc09e0b0300a767a350563cbfd88b4b85324ce4" \
	org.opencontainers.image.base.name="registry:2.7.1" \
	org.opencontainers.image.created="${org_opencontainers_image_created}" \
	org.opencontainers.image.description="A secure private docker registry." \
	org.opencontainers.image.licenses="Apache-2.0" \
	org.opencontainers.image.source="https://github.com/crashvb/registry-docker" \
	org.opencontainers.image.revision="${org_opencontainers_image_revision}" \
	org.opencontainers.image.title="crashvb/registry" \
	org.opencontainers.image.url="https://github.com/crashvb/registry-docker"

USER root

# Install packages, download files ...
ADD docker-* entrypoint /sbin/
RUN docker-apt gettext pwgen wget

# Configure: bash profile
RUN sed --in-place "s/HISTSIZE=1000/HISTSIZE=9999/g" /root/.bashrc && \
	sed --in-place "s/HISTFILESIZE=2000/HISTFILESIZE=99999/g" /root/.bashrc && \
	echo "# --- Docker Bash Profile ---" >> /root/.bashrc && \
	echo "set -o vi" >> /root/.bashrc && \
	echo "PS1='\${debian_chroot:+(\$debian_chroot)}\\\\t \[\\\\033[0;31m\]\u\[\\\\033[00m\]@\[\\\\033[7m\]\h\[\\\\033[00m\] [\w]\\\\n\$ '" >> /root/.bashrc && \
	touch ~/.hushlogin

# Configure: registry
ENV REGISTRY_HOME=/var/lib/registry
ENV REGISTRY_AUTH=htpasswd REGISTRY_AUTH_HTPASSWD_PATH=${REGISTRY_HOME}/.htpasswd REGISTRY_AUTH_HTPASSWD_REALM=Registry\ Secure\ Access

# Configure: entrypoint
RUN mkdir --mode=0755 --parents /etc/entrypoint.d/
ADD entrypoint.registry /etc/entrypoint.d/registry

ENTRYPOINT ["/sbin/entrypoint"]
CMD ["/bin/registry", "/etc/docker/registry/config.yml"]
