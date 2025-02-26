# Use an official Python runtime as a parent image
FROM python:3.10-slim

# Set environment variables
ENV ODOO_VERSION=17.0
ENV ODOO_REPO=https://github.com/OCA/OCB.git
ENV ODOO_HOME=/opt/odoo
ENV ODOO_CONF=${ODOO_HOME}/odoo.conf

# Install dependencies
RUN apt-get update && apt-get install -y \
    git \
    build-essential \
    libxml2-dev \
    libxslt1-dev \
    zlib1g-dev \
    libsasl2-dev \
    libldap2-dev \
    libssl-dev \
    libffi-dev \
    libjpeg-dev \
    libpq-dev \
    libjpeg62-turbo-dev \
    liblcms2-dev \
    libblas-dev \
    libatlas-base-dev \
    libtool \
    libevent-dev \
    libpng-dev \
    libxrender1 \
    libfontconfig1 \
    libx11-dev \
    libxext-dev \
    libxrender-dev \
    libzmq3-dev \
    pkg-config \
    python3-dev \
    python3-pip \
    postgresql-client \
    wget \
    xz-utils \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create odoo user
RUN useradd -m -U -r -d ${ODOO_HOME} -s /bin/bash odoo

# Clone Odoo repository
USER odoo
RUN git clone --depth 1 --branch ${ODOO_VERSION} ${ODOO_REPO} ${ODOO_HOME}/server

# Install Odoo Python dependencies
WORKDIR ${ODOO_HOME}/server

# Install problematic dependencies separately
RUN pip3 install cython==0.29.24 gevent==21.12.0 greenlet==1.1.2

# Install remaining dependencies from requirements file with increased timeout and no cache
RUN pip3 install --default-timeout=1000 -r requirements.txt

# Copy entrypoint script and Odoo configuration file
COPY ./entrypoint.sh /entrypoint.sh
COPY ./odoo.conf ${ODOO_CONF}

# Set permissions
USER root
RUN chown -R odoo: ${ODOO_HOME} /entrypoint.sh ${ODOO_CONF} \
    && chmod +x /entrypoint.sh

# Expose Odoo port
EXPOSE 8069

# Set the default entrypoint
ENTRYPOINT ["/entrypoint.sh"]

# Set the default command
CMD ["./odoo-bin", "--config", "/opt/odoo/odoo.conf"]