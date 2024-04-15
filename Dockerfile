# Define custom function directory
ARG FUNCTION_DIR="/function"

FROM python:3.9.18-slim-bullseye as build-image

# Include global arg in this stage of the build
ARG FUNCTION_DIR

# Install aws-lambda-cpp build dependencies
RUN apt-get update && \
  apt-get install -y \
  g++ \
  make \
  cmake \
  unzip \
  libcurl4-openssl-dev

RUN apt-get install -y --fix-missing \
    build-essential \
    cmake \
    gfortran \
    git \
    wget \
    curl \
    ffmpeg \ 
    libsm6 \
    libxext6 \
    graphicsmagick \
    libgraphicsmagick1-dev \
    libatlas-base-dev \
    libavcodec-dev \
    libavformat-dev \
    libgtk2.0-dev \
    libjpeg-dev \
    liblapack-dev \
    libswscale-dev \
    pkg-config \
    python3-dev \
    python3-numpy \
    software-properties-common \
    zip \
    && apt-get clean && rm -rf /tmp/* /var/tmp/*

# Copy function code
RUN mkdir -p ${FUNCTION_DIR}
COPY . ${FUNCTION_DIR}

WORKDIR ${FUNCTION_DIR}

RUN pip install --upgrade pip

RUN pip install -r requirements.txt --target ${FUNCTION_DIR}

# Install the function's dependencies
RUN pip install \
    --target ${FUNCTION_DIR} \
        awslambdaric

FROM python:3.9.18-slim-bullseye as runtime-image

# Include global arg in this stage of the build
ARG FUNCTION_DIR
# Set working directory to function root directory
WORKDIR ${FUNCTION_DIR}

ENV NUMBA_CACHE_DIR=/tmp

# Copy in the built dependencies
COPY --from=build-image ${FUNCTION_DIR} ${FUNCTION_DIR}

FROM runtime-image

COPY . ${FUNCTION_DIR}

ARG FUNCTION_DIR
# Set working directory to function root directory
WORKDIR ${FUNCTION_DIR}

ENV NUMBA_CACHE_DIR=/tmp
ENV MPLCONFIGDIR=/tmp

# Turn on Graviton2 optimization
ENV DNNL_DEFAULT_FPMATH_MODE=BF16
ENV LRU_CACHE_CAPACITY=1024

COPY ./entry.sh /entry.sh
RUN chmod +x /entry.sh
ADD aws-lambda-rie /usr/local/bin/aws-lambda-rie

ENTRYPOINT [ "/entry.sh", "app.lambda_handler" ]