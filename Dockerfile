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
  && apt-get install -y --no-install-recommends python3-pip=20.0.2-5ubuntu1.11 \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Add user with specified UID
RUN useradd -u 5002 -m -s /bin/bash user

# Make sure the application directory is owned by the user
RUN chown -R user:user $WORK_DIR

# Switch to the user for running the container
USER user

RUN pip3 install --no-cache-dir aiohttp==3.7.4
COPY src/. ./
RUN chmod +x ./main.sh
CMD ["./main.sh"]
