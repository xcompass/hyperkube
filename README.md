HyperKube with Ceph Common
==========================

**NOTE**! As coreos hyperkube image now includes ceph-common package. However, you can still use this repo for installing custom version of ceph-common.

The image is based on CoreOS HyperKube image with added Ceph common package. It tries to solve the problem the lack of rbd command in CoreOS image. It will help you to run CoreOS + Kubernetes + Ceph. This is a work around based on discussions here: https://github.com/kubernetes/kubernetes/issues/23924

Running
-------

```bash
docker run \
   --volume=/:/rootfs:ro \
   --volume=/sys:/sys:rw \                         # necessary to do mount from container
   --volume=/var/lib/docker/:/var/lib/docker:rw \
   --volume=/var/lib/kubelet/:/var/lib/kubelet:rw \
   --volume=/var/run:/var/run:rw \
   --volume=/sbin/modprobe:/sbin/modprobe:ro \     # to skip having to install in container
   --volume=/lib/modules:/lib/modules:ro \         # to make `modprobe rbd` work
   --volume=/etc/ceph:/etc/ceph:ro \               # to copy ceph config from host
   --volume=/dev/rbd0:/rootfs/dev/rbd0:ro \        # workaround for point 3 above
   --net=host \
   --pid=host \
   --privileged=true \
   --name=kubelet \
   -d \
   compass/hyperkube:${K8S_VERSION} \              # image with ceph-common vendored-in
   /hyperkube kubelet \
   --containerized \
   --hostname-override="127.0.0.1" \
   --address="0.0.0.0" \
   --api-servers=http://localhost:8080 \
   --config=/etc/kubernetes/manifests \
   --cluster-dns=10.0.0.10 \
   --cluster-domain=cluster.local \
   --allow-privileged=true --v=2
```

or with kubelet-wrapper using cloud-config

```bash
Environment=KUBELET_ACI=compass/hyperkube
... # the rest of your kubelet-wrapper
```
