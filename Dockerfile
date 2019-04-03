FROM loretoparisi/darknet

COPY . .

WORKDIR darknet

RUN if command -v nvcc ; then export GPU=1; else export GPU=0; fi

RUN GPU=$GPU OPENCV=1 CUDNN=$GPU make -j

ENTRYPOINT["python3", "darknet_video.py"]