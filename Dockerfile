ARG JL_BASE_VERSION=0.8.0-stable
ARG REGISTRY=scidockreg.esac.esa.int:62530
FROM ${REGISTRY}/datalabs/datalabs_base:${JL_BASE_VERSION}-20.04
ENV DEBIAN_FRONTEND noninteractive
LABEL maintainer="nmaltsev@argans.eu"
EXPOSE 10000
EXPOSE 8000
ARG WORK_DIR="/opt"
WORKDIR $WORK_DIR
RUN apt-get update \
  && apt-get install python3-pip
RUN pip3 install --no-cache-dir aiohttp==3.7.4
COPY src/. ./
RUN chmod +x ./main.sh
CMD ["./main.sh"]
