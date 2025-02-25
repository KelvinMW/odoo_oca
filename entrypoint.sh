#!/bin/bash

set -e

# Set default values if not provided
: ${ODOO_CONF:=/opt/odoo/odoo.conf}

# Wait for PostgreSQL
while ! pg_isready -h $PGHOST -p $PGPORT -U $PGUSER > /dev/null 2> /dev/null; do
    echo "Waiting for PostgreSQL to start..."
    sleep 1
done

# Run Odoo
exec "$@"
