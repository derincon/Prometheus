# Prometheus in Docker managed by Systemd
Dockerfile to buil prometheus 2.x in Docker managed by systemd 

##Download Prometheus for Linux: 
https://prometheus.io/download/

###Build Image
```
docker build -t davidrepo/prometheus-cti:v1.7 .
```
###Run Container
```
docker run --privileged -d \
		   --restart always \
		   --hostname prometheus-dev \
		   --add-host lnx1.strix:192.168.0.53 \
		   --add-host lnx2.strix:192.168.0.54 \
		   --add-host lnx3.strix:192.168.0.55 \
		   --dns 192.168.0.1 \
		   --domainname strix \
		   --name prometheus-dev \
		   -p 9091:9090 \
		   -v /tmp/$(mktemp -d):/run \
		   -v /sys/fs/cgroup:/sys/fs/cgroup:ro \
		   -v /prometheus/systemd/prometheus.service:/etc/systemd/system/prometheus.service \
		   -v /prometheus/customer-2/data:/prometheus/data \
		   -v /prometheus/customer-2/conf/alertrules.yml:/prometheus/conf/alertrules.yml \
		   -v /prometheus/customer-2/conf/prometheus.yml:/prometheus/conf/prometheus.yml prometheus-cti:v1.6
```