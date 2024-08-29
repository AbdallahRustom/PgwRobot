FROM alpine:3.19.1

# Install required packages
RUN apk update && \
    apk add --no-cache \
        python3 \
        py3-pip \
        git \
        nano \
        tcpdump \
        iproute2 \
        openssl

# Set up a virtual environment
RUN python3 -m venv /venv
ENV PATH="/venv/bin:$PATH"

# Set the working directory
WORKDIR /pgwrobot

# Clone the repository and Set permissions for the cloned repository
RUN git clone -b Feature/PCO https://github.com/AbdallahRustom/pgwrobot.git . \
&& chmod -R 777 /pgwrobot

# Install Python packages inside the virtual environment
RUN pip install --no-cache-dir \
        scapy \
        redis \
        pyyaml \
        jinja2 \
        robotframework 

# Copy the initialization script
COPY init.sh /init.sh

# Set execute permission for the initialization script
RUN chmod 777 /init.sh

# Set the entrypoint
ENTRYPOINT ["sh","/init.sh"]
