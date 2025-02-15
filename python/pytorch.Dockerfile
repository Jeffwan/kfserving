FROM ubuntu:16.04

RUN apt-get update && apt-get install -y --no-install-recommends \
         build-essential \
         git \
         curl \
         ca-certificates \
         libjpeg-dev \
         libpng-dev && \
     rm -rf /var/lib/apt/lists/*

RUN curl -o ~/miniconda.sh -O  https://repo.continuum.io/miniconda/Miniconda3-4.2.12-Linux-x86_64.sh  && \
     chmod +x ~/miniconda.sh && \
     ~/miniconda.sh -b -p /opt/conda && \
     rm ~/miniconda.sh && \
     /opt/conda/bin/conda install conda-build && \
     /opt/conda/bin/conda create -y --name pytorch-py37 python=3.7.3 numpy pyyaml scipy ipython mkl&& \
     /opt/conda/bin/conda clean -ya
ENV PATH /opt/conda/envs/pytorch-py37/bin:$PATH
RUN conda install --name pytorch-py37 pytorch torchvision -c soumith && /opt/conda/bin/conda clean -ya

WORKDIR /workspace
RUN chmod -R a+w /workspace

COPY . .
RUN pip install --upgrade pip && pip install -e ./kfserving
RUN pip install -e ./pytorchserver
ENTRYPOINT ["python", "-m", "pytorchserver"]