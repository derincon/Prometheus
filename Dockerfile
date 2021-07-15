ARG  CODE_VERSION=7-slim
ARG  PROMETHEUS_VERSION=2.28
FROM oraclelinux:${CODE_VERSION}
LABEL company="Charles Taylor InsureTech"
LABEL version="2.0"
LABEL description="Prometheus version $PROMETHEUS_VERSION"

COPY latest/prometheus        	   /prometheus/bin/prometheus
COPY latest/promtool          	   /prometheus/bin/promtool
COPY latest/prometheus.yml  	   /prometheus/conf/prometheus.yml
COPY latest/console_libraries/     /prometheus/console_libraries/
COPY latest/consoles/              /prometheus/consoles/
COPY latest/LICENSE                /prometheus/LICENSE
COPY latest/NOTICE                 /prometheus/NOTICE
COPY systemd/prometheus.service    /etc/systemd/system/prometheus.service

RUN yum update -y && \
	yum clean all && \
	yum -y install systemd && \
	yum clean all && \
	(cd /lib/systemd/system/sysinit.target.wants/; for i in ; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done) && \
	rm -rf /lib/systemd/system/multi-user.target.wants/ && \
	rm -rf /etc/systemd/system/.wants/ && \
	rm -rf /lib/systemd/system/local-fs.target.wants/ && \
	rm -rf /lib/systemd/system/sockets.target.wants/udev && \
	rm -rf /lib/systemd/system/sockets.target.wants/initctl && \
	rm -rf /lib/systemd/system/basic.target.wants/ && \
	rm -rf /lib/systemd/system/anaconda.target.wants/* && \
	systemctl enable prometheus.service && \
	/bin/cp /etc/skel/.bashrc /root/ && \
	source /root/.bashrc && \
	mkdir /etc/systemd/system/ \
	mkdir -p /prometheus/data && \
    chown -R root:root /prometheus

USER       root
EXPOSE     9090
VOLUME     [ "/prometheus" ]
WORKDIR    /prometheus
CMD ["/usr/sbin/init"]