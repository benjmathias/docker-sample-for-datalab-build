ARG JL_BASE_VERSION=stable
ARG REGISTRY=scidockreg.esac.esa.int:62530
FROM ${REGISTRY}/datalabs/jl_base:${JL_BASE_VERSION}

ENV DEBIAN_FRONTEND noninteractive
LABEL maintainer="bmathias@esa.int"

# The standard Jupyter port is 10000 in ESA Datalabs
EXPOSE 10000

# Install your custom python package into the existing conda environment
RUN /opt/miniconda/bin/pip install --no-cache-dir aiohttp==3.7.4

# Copy your custom application so it can be used from notebooks
COPY src/app.py /opt/datalab/custom_app.py

# Overwrite the start.sh with our custom one to ensure it runs
# the correct version of jupyter and has the correct paths.
COPY start.sh /opt/datalab/start.sh
RUN chmod +x /opt/datalab/start.sh

# Use standard datalab entrypoint
CMD ["/sbin/tini", "--", "/.datalab/run.sh"]
