FROM gcc:4.9

RUN apt-get update
RUN apt-get install -y cmake

# OpenMPI
RUN cd /usr/src && \
    wget https://www.open-mpi.org/software/ompi/v2.0/downloads/openmpi-2.0.1.tar.gz && \
    tar zxvf openmpi-2.0.1.tar.gz && \
    rm -f openmpi-2.0.1.tar.gz
RUN cd /usr/src/openmpi-2.0.1 && \
    ./configure --enable-mpi-thread-multiple --prefix=/usr/local && \
    make -j4 && make install

#libflame
RUN cd /usr/src && \
    git clone https://github.com/flame/libflame.git
RUN cd /usr/src/libflame && \
    ./configure --prefix=/usr/local/flame && \
    make -j4 && make install

#OpenBLAS
RUN cd /usr/src && \
    wget http://github.com/xianyi/OpenBLAS/archive/v0.2.19.tar.gz && \
    tar zxvf v0.2.19.tar.gz && \
    rm -f v0.2.19.tar.gz
RUN cd /usr/src/OpenBLAS-0.2.19 && \
    make BINARY=64 USE_OPENMP=1 && \
    make PREFIX=/usr/local/openblas/0.2.19/ install

#Elemental
RUN cd /usr/src && \
    wget http://libelemental.org/pub/releases/Elemental-0.84-p1.tgz && \
    tar zxvf Elemental-0.84-p1.tgz && \
    rm -f Elemental-0.84-p1.tgz

RUN cd /usr/src/Elemental-0.84-p1 && \
    sed -i -e "s/HYBRID/ELEM_HYBRID/g" cmake/tests/OpenMP.cmake && \
    sed -i -e "s/PURE/ELEM_PURE/g" cmake/tests/Math.cmake

ENV PATH $PATH:/usr/local/bin
ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:/usr/local/lib;/usr/local/openblas/0.2.19/lib

RUN mkdir /usr/src/Elemental-0.84-p1/build_hybrid
RUN cd /usr/src/Elemental-0.84-p1/build_hybrid && \
    cmake -D CMAKE_INSTALL_PREFIX=/usr/local/elemental/0.84-p1/HybridRelease \
    -D CMAKE_BUILD_TYPE=HybridRelease \
    -D MATH_LIBS="/usr/local/flame/lib/libflame.a;-L/usr/local/openblas/0.2.19/lib -lopenblas -lm" \
    -D ELEM_EXAMPLES=ON -D ELEM_TESTS=ON  ..
RUN cd /usr/src/Elemental-0.84-p1/build_hybrid && make -j4 && make install

RUN mkdir /usr/src/Elemental-0.84-p1/build_pure
RUN cd /usr/src/Elemental-0.84-p1/build_pure && \
    cmake -D CMAKE_INSTALL_PREFIX=/usr/local/elemental/0.84-p1/PureRelease \
    -D CMAKE_BUILD_TYPE=PureRelease \
    -D MATH_LIBS="/usr/local/flame/lib/libflame.a;-L/usr/local/openblas/0.2.19/lib -lopenblas -lm" \
    -D ELEM_EXAMPLES=ON -D ELEM_TESTS=ON  ..
RUN cd /usr/src/Elemental-0.84-p1/build_pure && make -j4 && make install

#SmallK
RUN cd /usr/src && \
    git clone https://github.com/smallk/smallk

ENV ELEMENTAL_INSTALL_DIR /usr/local/elemental
ENV ELEMVER 0.84-p1

RUN cd /usr/src/smallk && make all && make install

ENV PATH $PATH:/usr/local/smallk/bin
