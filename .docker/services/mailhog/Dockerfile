FROM mailhog/mailhog:v1.0.1

ENV TZ=UTC

HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=3 \
  CMD wget --quiet --tries=1 --spider http://localhost:8025/ || exit 1