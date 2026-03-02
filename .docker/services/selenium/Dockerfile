FROM selenium/standalone-chrome:144.0

ENV TZ=UTC

HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=5 \
  CMD curl -f http://localhost:4444/status || exit 1
