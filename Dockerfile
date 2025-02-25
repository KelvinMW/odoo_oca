FROM tecnativa/doodba:latest  # Or a specific version if needed
MAINTAINER Your Name <your.email@example.com>

# Optional:  Add any additional system-level dependencies here if needed
# RUN apt-get update && apt-get install -y --no-install-recommends <package_name>

# Important:  The Doodba magic happens automatically based on what's in `custom/`
# Example (replace with the actual SHA256):
#    FROM tecnativa/doodba@sha256:abcdef1234567890abcdef1234567890abcdef1234567890abcdef1234567890