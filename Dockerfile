ARG ALPINE_BASE=3.21

ARG SNAPCAST_VERSION=v0.32.3

# SnapCast build stage
#FROM alpine:$ALPINE_BASE as build

#ARG SNAPCAST_VERSION

#WORKDIR /root
## Dummy file is needed, because there's no conditional copy
#COPY dummy qemu-*-static /usr/bin/

#RUN apk -U add alsa-lib-dev avahi-dev bash build-base ccache cmake expat-dev flac-dev git libvorbis-dev opus-dev soxr-dev \
# && git clone --recursive https://github.com/badaix/snapcast --branch $SNAPCAST_VERSION \
# && cd snapcast \
# && wget https://boostorg.jfrog.io/artifactory/main/release/1.76.0/source/boost_1_76_0.tar.bz2 && tar -xjf boost_1_76_0.tar.bz2 \
# && cmake -S . -B build -DBOOST_ROOT=boost_1_76_0 -DCMAKE_CXX_COMPILER_LAUNCHER=ccache -DBUILD_WITH_PULSE=OFF -DCMAKE_BUILD_TYPE=Release -DBUILD_SERVER=OFF .. \
# && cmake --build build --parallel 3


FROM alpine:$ALPINE_BASE
WORKDIR /root

ARG SNAPCAST_VERSION
ARG BUILD_DATE
ARG VERSION
ARG VCS_REF

LABEL org.label-schema.build-date=$BUILD_DATE \
    org.label-schema.name="docker-snapclient" \
    org.label-schema.version=$VERSION \
    org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.vcs-url="https://github.com/rugarci/docker-snapclient" \
    org.label-schema.vcs-type="Git" \
    org.label-schema.schema-version="1.0" \
    org.opencord.component.snapcast.version=$SNAPCAST_VERSION \
    org.opencord.component.snapcast.vcs-url="https://github.com/badaix/snapcast"

RUN apk --no-cache add alsa-lib avahi-libs expat flac libvorbis opus soxr snapcast~=${SNAPCAST_VERSION}

#COPY --from=build /root/snapcast/bin/snapclient /usr/bin

ENTRYPOINT ["/usr/bin/snapclient"]
