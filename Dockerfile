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

# hadolint ignore=DL3002
USER root

# Install packages, download files ...
COPY docker-* entrypoint /sbin/
COPY entrypoint.sh /usr/local/lib/
RUN apk add --no-cache bash && \
	docker-apk apache2-utils gettext openssl pwgen wget

# Configure: bash profile
COPY bashrc.root /root/.bashrc
# hadolint ignore=SC2016
RUN sed -e "s|/ash|/bash|g" -i /etc/passwd && \
	echo '[[ -n "$BASH_VERSION" && -f "$HOME/.bashrc" ]] && source "$HOME/.bashrc"' > /root/.profile

# Configure: registry
ENV \
	REGISTRY_AUTH=htpasswd \
	REGISTRY_AUTH_HTPASSWD_PATH=/var/lib/registry/.htpasswd \
	REGISTRY_AUTH_HTPASSWD_REALM=Registry\ Secure\ Access \
	REGISTRY_HTTP_TLS_CERTIFICATE=/etc/ssl/certs/registry.crt \
	REGISTRY_HTTP_TLS_KEY=/etc/ssl/private/registry.key

# Configure: entrypoint
# hadolint ignore=SC2174
RUN mkdir --mode=0755 --parents /etc/entrypoint.d/
COPY entrypoint.registry /etc/entrypoint.d/registry

ENTRYPOINT ["/sbin/entrypoint"]
CMD ["/bin/registry", "serve", "/etc/docker/registry/config.yml"]
