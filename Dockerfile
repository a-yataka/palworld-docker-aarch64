FROM arm64v8/ubuntu:22.04
RUN apt update && apt upgrade -y
RUN apt install -y git build-essential cmake
RUN apt-get install -y python3-pip curl

# x86
WORKDIR /usr/local
RUN git clone https://github.com/ptitSeb/box86
RUN dpkg --add-architecture armhf
RUN apt update
RUN apt install -y gcc-arm-linux-gnueabihf libc6:armhf libncurses5:armhf libstdc++6:armhf
WORKDIR /usr/local/box86
RUN mkdir build
WORKDIR /usr/local/box86/build
RUN cmake .. -DRPI4ARM64=1 -DCMAKE_BUILD_TYPE=RelWithDebInfo; make -j$(nproc)
RUN make install

# x64
WORKDIR /usr/local
RUN git clone https://github.com/ptitSeb/box64.git
WORKDIR /usr/local/box64
RUN mkdir build
WORKDIR /usr/local/box64/build
RUN cmake .. -DARM_DYNAREC=ON -DCMAKE_BUILD_TYPE=RelWithDebInfo; make -j$(nproc)
RUN make install

RUN apt install python3-pip
RUN pip3 install --upgrade requests

RUN mkdir /usr/local/steamcmd
WORKDIR /usr/local/steamcmd

RUN adduser --disabled-password paladmin
WORKDIR /usr/local/steamcmd
RUN chown paladmin /usr/local/steamcmd
RUN mkdir -p /srv/palworld
RUN chown paladmin /srv/palworld
USER paladmin
RUN curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar -xz
RUN box64 /usr/local/box64/tests/bash /usr/local/steamcmd/steamcmd.sh +force_install_dir /srv/palworld +login anonymous +app_update 2394010 validate +quit
WORKDIR /srv/palworld
RUN mkdir -p /home/paladmin/.steam/sdk64/
RUN cp /srv/palworld/linux64/steamclient.so /home/paladmin/.steam/sdk64/steamclient.so

ENTRYPOINT [ "box64", "/usr/local/box64/tests/bash", "/srv/palworld/PalServer.sh", "port=8211", "-useperfthreads", "-NoAsyncLoadingThread", "-UseMultithreadForDS" ]

# TODO: 
#   - multi stage build
#   - volume permission
