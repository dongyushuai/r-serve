FROM r-base:latest

MAINTAINER Dong dongyshd@gmail.com

RUN apt-get update && apt-get install telnet -y

ARG doi_network=false

RUN if [ "${doi_network}" = true ]; then \
		/usr/bin/wget -O /usr/lib/ssl/certs/DOIRootCA.crt http://blockpage.doi.gov/images/DOIRootCA.crt && \
		ln -sf /usr/lib/ssl/certs/DOIRootCA.crt /usr/lib/ssl/certs/`openssl x509 -hash -noout -in /usr/lib/ssl/certs/DOIRootCA.crt`.0 && \
		echo "\\n\\nca-certificate = /usr/lib/ssl/certs/DOIRootCA.crt" >> /etc/wgetrc; \
	fi

RUN R -e "install.packages('Rserve')"

ENV RSERVE_HOME /opt/rserve

RUN useradd rserve \
	&& mkdir ${RSERVE_HOME} \
	&& usermod -d ${RSERVE_HOME} rserve


COPY etc ${RSERVE_HOME}/etc

RUN chown -R rserve:rserve ${RSERVE_HOME}

COPY run_rserve.sh ${RSERVE_HOME}/bin/

RUN chmod 755 ${RSERVE_HOME}/bin/run_rserve.sh

USER rserve

## Change username and provide PASSWORD
ENV USERNAME ${USERNAME:-rserve}

ENV PASSWORD ${PASSWORD:-rserve}

RUN mkdir ${RSERVE_HOME}/work

EXPOSE 6311

HEALTHCHECK --interval=2s --timeout=3s \
 CMD sleep 1 | \
 		telnet localhost 6311 | \
		grep -q Rsrv0103QAP1 || exit 1

CMD ["/opt/rserve/bin/run_rserve.sh"]
