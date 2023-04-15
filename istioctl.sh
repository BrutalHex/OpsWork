!#/bin/bash
curl -L https://istio.io/downloadIstio | ISTIO_VERSION=1.16.1 sh -
mv ./istio-1.16.1 /usr/bin/
ln -s /usr/bin/istio-1.16.1/bin/istioctl /usr/bin/istioctl