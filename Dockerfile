ARG JL_BASE_VERSION=0.8.0-stable
ARG REGISTRY=scidockreg.esac.esa.int:62530
FROM ${REGISTRY}/datalabs/datalabs_base:${JL_BASE_VERSION}-20.04
ENV DEBIAN_FRONTEND noninteractive
LABEL maintainer="nmaltsev@argans.eu"

# Standard ESA Datalabs Jupyter port
EXPOSE 10000

ARG WORK_DIR="/opt/datalab"
WORKDIR $WORK_DIR

# Install Python packages including Jupyter
RUN apt-get update \
  && apt-get install -y --no-install-recommends python3-pip curl \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Install Jupyter and your custom packages
RUN pip3 install --no-cache-dir \
    jupyterlab==3.6.3 \
    aiohttp==3.7.4

# Copy your custom application
COPY src/app.py ./custom_app.py

# Copy the Jupyter start script
COPY start.sh ./start.sh

# Set executable permissions
RUN chmod +x ./start.sh

# Set permissions for runtime user
RUN chmod -R 755 $WORK_DIR

# Use standard datalab entrypoint
CMD ["/sbin/tini", "--", "/.datalab/run.sh"]
