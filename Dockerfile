FROM --platform=linux/amd64 python:3.10-bookworm

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get -y install --no-install-recommends \
        libgl1 \
        ffmpeg

WORKDIR /app

COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

RUN huggingface-cli download ByteDance/LatentSync-1.5 whisper/tiny.pt --local-dir checkpoints \
    && huggingface-cli download ByteDance/LatentSync-1.5 latentsync_unet.pt --local-dir checkpoints

COPY . /app/
