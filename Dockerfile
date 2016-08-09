FROM quay.io/coreos/hyperkube:v1.3.4_coreos.0

RUN curl https://raw.githubusercontent.com/ceph/ceph/master/keys/release.asc | apt-key add - && \
    echo deb http://download.ceph.com/debian-jewel/ jessie main | tee /etc/apt/sources.list.d/ceph.list && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -q -y ceph-common && \
    EBIAN_FRONTEND=noninteractive apt-get autoremove -y && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
