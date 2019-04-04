FROM loretoparisi/darknet

RUN apt-get update && apt-get install -y --no-install-recommends \
    python3.5 \
    python3-pip \
    && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY . .

WORKDIR darknet

RUN if command -v nvcc ; then export GPU=1; else export GPU=0; fi

RUN GPU=$GPU OPENCV=1 CUDNN=$GPU make -j

ENTRYPOINT ["sh", "-c", "python3.5 darknet_video.py"]