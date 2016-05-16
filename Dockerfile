FROM golang:1.6

MAINTAINER Adam Avilla <aavilla@yp.com>


# Install Ceph.
ENV CEPH_VERSION jewel
ENV SRC_ROOT /go/src/github.com/yp-engineering/rbd-docker-plugin

RUN wget -q -O- 'https://download.ceph.com/keys/release.asc' | apt-key add - && \
    echo deb http://download.ceph.com/debian-${CEPH_VERSION}/ jessie main | tee /etc/apt/sources.list.d/ceph.list && \
    apt-get update && \
    apt-get -y upgrade && \
    apt-get install -y --force-yes \
        librados-dev \
        librbd-dev \
        ceph  && \
    mkdir -p ${SRC_ROOT} && \
    ln -s ${SRC_ROOT} /rbd-docker-plugin
WORKDIR ${SRC_ROOT}

# Used to only go get if sources change.
ADD *.go ${SRC_ROOT}/
RUN go get -t .

# Add the rest of the files.
ADD . ${SRC_ROOT}


# Clean up all the apt stuff
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


CMD ["bash"]
