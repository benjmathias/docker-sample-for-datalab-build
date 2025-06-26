ARG JL_BASE_VERSION=0.8.0-stable
ARG REGISTRY=scidockreg.esac.esa.int:62530
FROM ${REGISTRY}/datalabs/datalabs_base:${JL_BASE_VERSION}-20.04
ENV DEBIAN_FRONTEND noninteractive
LABEL maintainer="nmaltsev@argans.eu"
EXPOSE 10000
EXPOSE 8000
ARG WORK_DIR="/opt/datalab"
WORKDIR $WORK_DIR

# Run apt operations
RUN apt-get update \
  && apt-get install -y --no-install-recommends python3-pip=20.0.2-5ubuntu1.11 \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Install Python packages
RUN pip3 install --no-cache-dir aiohttp==3.7.4

# Copy application files to the standard datalab location
COPY src/app.py ./
COPY src/main.sh ./start.sh

# Set executable permission for scripts
RUN chmod +x ./start.sh

# Set permissions that will allow the runtime user to access files
RUN chmod -R 755 $WORK_DIR

# Use the standard datalab entrypoint
CMD ["/sbin/tini", "--", "/.datalab/run.sh"]
