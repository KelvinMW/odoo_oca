# Set the base image to the official Odoo image
FROM odoo:17.0

# Set environment variables
ENV ODOO_VERSION=17.0
ENV ODOO_REPO=https://github.com/OCA/OCB.git
ENV ODOO_HOME=/opt/odoo
ENV ODOO_CONF=${ODOO_HOME}/odoo.conf

# Install additional dependencies
USER root
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

# Clone Odoo repository
USER odoo
RUN git clone --depth 1 --branch ${ODOO_VERSION} ${ODOO_REPO} ${ODOO_HOME}/server

# Set the working directory
WORKDIR ${ODOO_HOME}/server

# Install Python dependencies
USER root
RUN pip3 install cython==0.29.24 gevent==21.12.0 greenlet==1.1.2
RUN pip3 install --default-timeout=1000 -r requirements.txt

# Copy the entrypoint script and Odoo configuration file
COPY ./entrypoint.sh /entrypoint.sh
COPY ./odoo.conf ${ODOO_CONF}

# Set permissions
RUN chown -R odoo: ${ODOO_HOME} /entrypoint.sh ${ODOO_CONF} && chmod +x /entrypoint.sh

# Expose the Odoo port
EXPOSE 8069

# Set the default entrypoint
ENTRYPOINT ["/entrypoint.sh"]

# Set the default command
CMD ["./odoo-bin", "--config", "/opt/odoo/odoo.conf"]