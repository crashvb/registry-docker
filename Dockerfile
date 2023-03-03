FROM crashvb/base:22.04-202303031605@sha256:ffa63321cadb7fdc937508b2976c6f919576bcbe93122a27fded24343d818315 AS parent

FROM registry:2.8.1@sha256:a001a2f72038b13c1cbee7cdd2033ac565636b325dfee98d8b9cc4ba749ef337
ARG org_opencontainers_image_created=undefined
ARG org_opencontainers_image_revision=undefined
LABEL \
	org.opencontainers.image.authors="Richard Davis <crashvb@gmail.com>" \
	org.opencontainers.image.base.digest="sha256:a001a2f72038b13c1cbee7cdd2033ac565636b325dfee98d8b9cc4ba749ef337" \
	org.opencontainers.image.base.name="registry:2.8.1" \
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
COPY --from=parent /sbin/entrypoint /sbin/healthcheck /sbin/
COPY --from=parent /usr/local/lib/entrypoint.sh /usr/local/lib/
COPY alpine-fixes docker-* /sbin/
# hadolint ignore=DL3018
RUN apk add --no-cache bash && \
	docker-apk apache2-utils gettext openssl pwgen wget && \
	alpine-fixes

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
RUN mkdir --mode=0755 --parents /etc/entrypoint.d/ /etc/healthcheck.d/
COPY entrypoint.registry /etc/entrypoint.d/registry

# Configure: healthcheck
COPY healthcheck.registry /etc/healthcheck.d/registry

HEALTHCHECK CMD /sbin/healthcheck

ENTRYPOINT ["/sbin/entrypoint"]
CMD ["/bin/registry", "serve", "/etc/docker/registry/config.yml"]
