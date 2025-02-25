#!/bin/bash

set -e

# Set default values if not provided
: ${ODOO_CONF:=/opt/odoo/odoo.conf}

# Wait for PostgreSQL
echo "Checking PostgreSQL connection..."
while ! pg_isready -h ${PGHOST} -p ${PGPORT} -U ${PGUSER}; do
    echo "Waiting for PostgreSQL to start..."
    sleep 1
done

echo "PostgreSQL is up and running."

# Run Odoo
exec "$@"