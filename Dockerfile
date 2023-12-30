FROM registry.fedoraproject.org/fedora:39

RUN dnf install -y --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' --setopt='terra.gpgkey=https://repos.fyralabs.com/terra$releasever/key.asc' terra-release
# We need icecc-create-env to be in path, so we can do cross-compilation
RUN dnf install -y sccache gcc gcc-c++ git bubblewrap curl gettext-envsubst jq icecream

RUN dnf clean all
RUN rm -rf /var/cache/{dnf,yum}

COPY config.toml /opt/config.toml.tmpl

COPY dist-server.sh /opt/dist-server.sh
RUN chmod +x /opt/dist-server.sh

ENTRYPOINT ["/opt/dist-server.sh"]
CMD ["/opt/dist-server.sh"]