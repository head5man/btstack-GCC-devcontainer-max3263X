# ------------------------------------------------------------------------------
# Pull base image
FROM ubuntu:22.04 AS base

    # ------------------------------------------------------------------------------
    # Arguments
    ARG WORKDIR=/root

    # ------------------------------------------------------------------------------
    # Install tools via apt
    ENV DEBIAN_FRONTEND=noninteractive
    RUN set -x \
        && apt -y update \
        && apt -y install \
        git \
        wget curl unzip \
        build-essential \
        astyle mercurial ninja-build \
        libssl-dev \
        cargo flex bison \
        doxygen \
        aspell \
        cmake ccache \
        gcovr \
        valgrind \
        && : # last line

FROM base AS locale

    ENV LANG=en_US.utf8
    ENV LANGUAGE=en_US.UTF-8
    ENV LC_ALL=en_US.UTF-8
    
    # Tools and config missing from the build image
    RUN apt-get update
    RUN apt-get install -y locales && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

FROM locale AS pytools

    RUN set -x \
        && apt -y install \
        python3 python3-dev python3-setuptools python3-pip \
    && : # last line

    RUN pip3 install pycryptodomex
    RUN pip3 install virtualenv

FROM pytools AS interaction
        
    RUN apt-get -fy install vim nano bash-completion gdb docker.io

FROM interaction AS toolchain
    # ------------------------------------------------------------------------------
    # Install arm-none-eabi-gcc
    #WORKDIR /opt/mbed-os-toolchain
    WORKDIR /usr/local
    # older toolchain download - https://developer.arm.com/-/media/Files/downloads/gnu-rm/$RELEASE/${TARBALL}
    # ARG RELEASE="10.3-2021.10"
    # ARG GCC_PATH="/usr/local/gcc-arm-none-eabi-$RELEASE"
    # RUN set -x \
    #     && [ "$(uname -m)" = "aarch64" ] && \
    #         ARCH="aarch64" || \
    #         ARCH="x86_64" \
    #     && TARBALL="gcc-arm-none-eabi-$RELEASE-${ARCH}-linux.tar.bz2" \
    #     && wget -q https://developer.arm.com/-/media/Files/downloads/gnu-rm/$RELEASE/${TARBALL} \
    #     && [ -f ${TARBALL} ] \
    #     && tar -xf ${TARBALL} \
    #     && rm ${TARBALL} \
    #     && : # last line
    
    # ENV TOOLCHAIN_PATH=$GCC_PATH
    # ENV PATH="${GCC_PATH}/bin:${PATH}"
    
    # newer toolchain download - https://developer.arm.com/-/media/Files/downloads/gnu/$RELEASE/binrel/${TARBALL}
    ARG RELEASE="12.2.rel1"
    ARG GCC_PATH="/usr/local/gcc-arm-none-eabi-$RELEASE"
    
    RUN set -x \
        && [ "$(uname -m)" = "aarch64" ] && \
            ARCH="aarch64" || \
            ARCH="x86_64" \
        && TOOLCHAIN="arm-gnu-toolchain-$RELEASE-$ARCH-arm-none-eabi" \
        && TARBALL="${TOOLCHAIN}.tar.xz" \
        && wget -q https://developer.arm.com/-/media/Files/downloads/gnu/$RELEASE/binrel/${TARBALL} \
        && [ -f $TARBALL ] \
        && : # last line
    
    RUN set -x \
        && tar -xf arm-gnu-toolchain*.tar.xz \
        && : # last line

    RUN set -x \
        && rm arm-gnu-toolchain*.tar.xz \
        && mv "$(ls . | grep arm-gnu-tool)" ${GCC_PATH} \
        && : # last line

    ENV TOOLCHAIN_PATH=$GCC_PATH
    ENV PATH="${TOOLCHAIN_PATH}/bin:${PATH}"

FROM toolchain AS user

    ############################
    
    # This Dockerfile contains things useful for an interactive development environment
    ARG USERNAME=vscode
    ARG USER_UID=1000
    ARG USER_GID=$USER_UID
    
    RUN apt-get -fy install sudo
    # Create the user
    RUN groupadd -g $USER_GID $USERNAME
    RUN useradd -s /bin/bash -u $USER_UID -g $USER_GID -G docker -m $USERNAME
    RUN echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME
    RUN chmod 0440 /etc/sudoers.d/$USERNAME
    
    # Give user access to toolchan
    RUN chmod 755 /root
    
    # ********************************************************
    # * Anything else you want to do like clean up goes here *
    # ********************************************************
    
    # [Optional] Set the default user. Omit if you want to keep the default as root.
    USER $USERNAME
    
    # [Optional] Uncomment this section to install additional packages.
    # RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    #     && apt-get -y install --no-install-recommends <your-package-list-here>
    
    ### The following sdk installation would be nice ###
    ### but no the max32630 is not included in the SDK
    # # install MaximSDK dependencies
    # RUN set -x && apt-get install -y libxcb-glx0 && :
    # RUN set -x && apt-get install -y libxcb-icccm4 && :
    # RUN set -x && apt-get install -y libxcb-image0 libxcb-shm0 && :
    # RUN set -x && apt-get install -y libxcb-util1 libxcb-keysyms1 libxcb-randr0 libxcb-render-util0 && :
    # RUN set -x && apt-get install -y libxcb-render0 libxcb-shape0 libxcb-sync1 libxcb-xfixes0 && :
    # RUN set -x && apt-get install -y libxcb-xinerama0 libxcb-xkb1 libxcb1 && :
    # RUN set -x && apt-get install -y libxkbcommon-x11-0 libxkbcommon0 libgl1 libusb-0.1-4 && :
    # RUN set -x && apt-get install -y libhidapi-libusb0 libhidapi-hidraw0 && :
    #
    # COPY scripts/MaximMicrosSDK_linux.run /usr/local/MaximMicrosSDK_linux.run
    # RUN sudo chmod +x /usr/local/MaximMicrosSDK_linux.run
    # RUN sudo ./MaximMicrosSDK_linux.run in --root /usr/local/MaximSDK --accept-licenses --accept-messages --confirm-command
    # RUN sudo chown -R vscode:vscode /usr/local/MaximSDK
    ####################################################

FROM user AS symbolic
    # we have only one python and some of the scripts use python
    RUN sudo ln -s /usr/bin/python3 /usr/bin/python
