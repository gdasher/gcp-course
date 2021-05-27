FROM us-west1-docker.pkg.dev/gcp-security-dev-curriculum/elmer-repo/kube-openmpi-base:0.0.1
      
RUN apt-get update && apt-get install -yq --no-install-recommends \
      git cmake build-essential gfortran libopenmpi-dev python3 \
      dnsutils curl libblas-dev liblapack-dev libhypre-dev \
      libmumps-dev libscotchparmetis-dev libmetis-dev \
      apt-transport-https ca-certificates gnupg vim

RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" \
  | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list \
  && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg \
  | apt-key --keyring /usr/share/keyrings/cloud.google.gpg  add - \
  && apt-get update -y \
  && apt-get install google-cloud-sdk -y \
  && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

RUN  gcloud config configurations create default \
  && gcloud config configurations activate default \
  && gcloud config set project gcp-security-dev-curriculum \
  && gcloud config set compute/region us-west1

COPY path.patch /
RUN git clone https://github.com/ElmerCSC/elmerfem /elmerfem \
  && cd elmerfem \
  && git checkout tags/release-9.0
RUN patch -d /elmerfem -p1 < path.patch

WORKDIR /elmerfem

RUN git submodule sync \
  && git submodule update --init

WORKDIR /elmerfem/build
RUN cmake .. -DWITH_OpenMP:BOOLEAN=TRUE \
             -DWITH_MPI:BOOLEAN=TRUE \
             -DWITH_Zoltan:BOOLEAN=TRUE \
             -DWITH_Mumps:BOOLEAN=TRUE \
             -DWITH_Hypre:BOOLEAN=TRUE \
  && make \
  && make install
