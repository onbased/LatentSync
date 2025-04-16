FROM mcr.microsoft.com/devcontainers/python:1-3.10-bookworm

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get -y install --no-install-recommends \
        libgl1 \
        ffmpeg
