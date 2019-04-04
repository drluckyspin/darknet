FROM python:3.5.7

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# Various Python and C/build deps
RUN apt-get update && apt-get install -y \
    wget \
    build-essential \
    libc-dev \
    cmake \
    git \
    unzip \
    pkg-config \
    python-dev \
    python-opencv \
    libopencv-dev \
    libav-tools  \
    libjpeg-dev \
    libpng-dev \
    libtiff-dev \
    libgtk2.0-dev \
    python-numpy \
    python-pycurl \
    libatlas-base-dev \
    gfortran \
    webp \
    python-opencv \
    qt5-default \
    libvtk6-dev \
    zlib1g-dev

# Install Open CV - Warning, this takes absolutely forever
RUN mkdir -p ~/opencv cd ~/opencv && \
    wget https://github.com/Itseez/opencv/archive/3.4.0.zip && \
    unzip 3.4.0.zip && \
    rm 3.4.0.zip && \
    mv opencv-3.4.0 OpenCV && \
    cd OpenCV && \
    mkdir build && \
    cd build && \
    cmake \
    -DWITH_QT=ON \
    -DWITH_OPENGL=ON \
    -DFORCE_VTK=ON \
    -DWITH_TBB=ON \
    -DWITH_GDAL=ON \
    -DWITH_XINE=ON \
    -DBUILD_EXAMPLES=ON .. && \
    make -j4 && \
    make install && \
    ldconfig

WORKDIR OpenCV

#COPY requirements.txt /usr/src/app/
#RUN pip install --no-cache-dir -r requirements.txt

COPY . /usr/src/app

RUN git clone https://github.com/Xaoc000/darknet.git

WORKDIR darknet

RUN if command -v nvcc ; then export GPU=1; else export GPU=0; fi

RUN GPU=$GPU OPENCV=1 CUDNN=$GPU make -j

ENTRYPOINT ["sh", "-c", "python3 darknet_video.py"]