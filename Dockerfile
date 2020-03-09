FROM rust:latest

COPY bin/entrypoint.sh /entrypoint.sh

RUN cargo install cargo-release 

ENTRYPOINT ["/entrypoint.sh"]