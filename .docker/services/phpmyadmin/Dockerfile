FROM phpmyadmin:5-apache

ENV TZ=UTC \
    UPLOAD_LIMIT=2G \
    MEMORY_LIMIT=-1 \
    MAX_EXECUTION_TIME=9000 \
    MAX_INPUT_VARS=20000

# Set the upload, memory, and execution limits in PHP configuration
RUN echo "upload_max_filesize=${UPLOAD_LIMIT}" > /usr/local/etc/php/conf.d/uploads.ini && \
    echo "post_max_size=${UPLOAD_LIMIT}" >> /usr/local/etc/php/conf.d/uploads.ini && \
    echo "memory_limit=${MEMORY_LIMIT}" > /usr/local/etc/php/conf.d/memory.ini && \
    echo "max_execution_time=${MAX_EXECUTION_TIME}" > /usr/local/etc/php/conf.d/execution.ini && \
    echo "max_input_vars=${MAX_INPUT_VARS}" > /usr/local/etc/php/conf.d/input_vars.ini
