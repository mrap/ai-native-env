# E2E test image for ai-native-env install — clean Ubuntu with bash + zsh.
FROM ubuntu:24.04
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
        git zsh bash ca-certificates && rm -rf /var/lib/apt/lists/*
# Stub the optional deps so install.sh's check_deps passes without heavy installs.
RUN for b in tmux nvim fzf starship sesh zoxide bun; do \
        printf '#!/bin/sh\nexit 0\n' > /usr/local/bin/$b && chmod +x /usr/local/bin/$b; \
    done
ARG TEST_USER=tester
RUN useradd -m -s /bin/zsh ${TEST_USER}
