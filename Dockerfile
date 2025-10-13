# Minimal Docker image with latest PDAL from conda
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget \
    bzip2 \
    ca-certificates \
    curl \
    python3 \
    python3-numpy \
    python3-scipy \
    python3-pandas \
    rsync \
    bc \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

# Install uv (fast Python package installer)
RUN curl -LsSf https://astral.sh/uv/install.sh | sh
ENV PATH="/root/.local/bin:$PATH"

# Install Miniconda (minimal)
ENV CONDA_DIR=/opt/conda
RUN wget -q https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh && \
    bash miniconda.sh -b -p $CONDA_DIR && \
    rm miniconda.sh
ENV PATH=$CONDA_DIR/bin:$PATH

# Accept conda ToS and install latest PDAL from conda-forge (has threading support)
RUN conda config --set channel_priority strict && \
    conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/main && \
    conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/r && \
    conda install -c conda-forge pdal -y && \
    conda clean -afy

# Install Python packages using uv
RUN uv pip install --system \
    pydantic \
    pydantic-settings \
    tqdm \
    laspy[lazrs] \
    scipy


# Create directories
RUN mkdir -p /src /in /out && chmod 777 /src /in /out

# Copy application code
COPY ./src /src

# Create python symlink for convenience
RUN ln -s /usr/bin/python3 /usr/bin/python



WORKDIR /src
CMD ["python", "run.py"]

