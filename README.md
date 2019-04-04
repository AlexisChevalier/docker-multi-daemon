# docker-multi-daemon-osx

Simple tool to enable docker usage through multiple daemons on an OSX host

### Usage

- `./switchdocker.sh` Changes the flag to switch between local or remote daemon
- `./docker.sh [docker args...]` Runs docker or docker-compose with the appropriate daemon (assuming the docker exec has been renamed _docker)
- `./docker-compose.sh [docker-compose args...]` Runs docker or docker-compose with the appropriate daemon (assuming the docker-compose exec has been renamed _docker-compose)
