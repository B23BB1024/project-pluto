FROM ubuntu:22.04
RUN apt-get update && apt-get install -y bash coreutils gawk grep sed && rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY . /app
