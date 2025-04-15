###############
# LatentSync
###############

FROM --platform=linux/amd64 python:3.10-bookworm as latentsync

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get -y install --no-install-recommends \
        libgl1 \
        ffmpeg

ENV PYTHONPATH=/app
WORKDIR /app

COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

RUN huggingface-cli download ByteDance/LatentSync-1.5 whisper/tiny.pt --local-dir checkpoints \
    && huggingface-cli download ByteDance/LatentSync-1.5 latentsync_unet.pt --local-dir checkpoints

COPY . /app/


###############
# Runpod
###############

FROM latentsync as runpod

# sshd
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get -y install --no-install-recommends \
        openssh-server
RUN mkdir -p /run/sshd

# ssh
ENV PUBLIC_KEY=
RUN mkdir -p ~/.ssh && chmod 700 ~/.ssh
RUN touch ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys

# runpodctl
ENV RUNPOD_API_KEY=
RUN curl -sSfL https://github.com/runpod/runpodctl/releases/download/v1.14.4/runpodctl-linux-amd64 -o /usr/local/bin/runpodctl \
    && chmod +x /usr/local/bin/runpodctl \
    && mkdir -p ~/.runpod

# entrypoint
ENV KEEP_ALIVE_MINS=
ENTRYPOINT ["/app/runpod_entrypoint.sh"]
