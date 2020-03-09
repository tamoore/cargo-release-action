FROM mooretodd/cargo-release-action:latest

COPY bin/entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]