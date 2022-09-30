FROM tensorflow/tensorflow:2.6.0-gpu
RUN rm /etc/apt/sources.list.d/cuda.list
RUN rm /etc/apt/sources.list.d/nvidia-ml.list
# System packages.
RUN apt-get update && apt-get install -y \
  ffmpeg \
  libgl1-mesa-dev \
  python3-pip \
  unrar \
  unzip\
  wget \
  && apt-get clean

# COPY . /app
# WORKDIR /app
RUN pip install --upgrade pip
# RUN pip3 install -r requirement.txt

# # MuJoCo.
# # # install MuJoCo
# RUN mkdir -p /root/.mujoco \
#   && wget https://www.roboti.us/download/mujoco200_linux.zip -O mujoco.zip \
#   && unzip mujoco.zip -d /root/.mujoco \
#   && mv /root/.mujoco/mujoco200_linux /root/.mujoco/mujoco200 \
#   && rm mujoco.zip
# RUN echo "$MUJOCO_KEY" > /root/.mujoco/mjkey.txt
# COPY mjkey.txt /root/.mujoco/mjkey.txt
# ENV LD_LIBRARY_PATH /root/.mujoco/mujoco200/bin:${LD_LIBRARY_PATH}
#----------------
# Python packages.
# RUN pip3 install --no-cache-dir \
#   'gym[atari]' \
#   atari_py \
#   crafter \
#   dm_control \
#   ruamel.yaml \
#   tensorflow-probability==0.14.0\
#   keras==2.6.0


# Atari ROMS.
# RUN wget -L -nv http://www.atarimania.com/roms/Roms.rar && \
#   unrar x Roms.rar -y && \
#   unzip ROMS.zip -y && \
#   python3 -m atari_py.import_roms ROMS && \
#   rm -rf Roms.rar ROMS.zip ROMS

# Atari ROMS.
# RUN wget http://www.atarimania.com/roms/Roms.rar && \
#   unrar e Roms.rar -y && \
#   unzip ROMS.zip -y && \
#   unzip "HC ROMS.zip" && \
#   rm ROMS.zip && \
#   rm "HC ROMS.zip" && \
#   rm Roms.rar  

# # Atari ROMS
# RUN mkdir roms && \
#   cd roms && \
#   wget http://www.atarimania.com/roms/Roms.rar && \
#   unrar e Roms.rar -y && \
#   unzip ROMS.zip -y && \
#   unzip "HC ROMS.zip" -y && \
#   rm ROMS.zip && \
#   rm "HC ROMS.zip" && \
#   rm Roms.rar && \
#   python -m atari_py.import_roms .
#------------------

RUN wget -L -nv http://www.atarimania.com/roms/Roms.rar 
RUN  unrar e Roms.rar -y
RUN  unzip ROMS.zip -y 
#RUN  unzip "HC ROMS.zip" 
#RUN  rm ROMS.zip
#RUN  rm "HC ROMS.zip" 
RUN  rm Roms.rar  
RUN pip3 install 'gym[atari]' --no-cache-dir
RUN pip3 install atari_py
#RUN python3 -m atari_py.import_roms ROMS
RUN python3 -m atari_py.import_roms .
# DreamerV2.
ENV TF_XLA_FLAGS --tf_xla_auto_jit=2


CMD [ \
  "python3", "dreamerv2/train.py", \
  "--logdir", "/logdir/$(date +%Y%m%d-%H%M%S)", \
  "--configs", "defaults", "atari", \
  "--task", "atari_pong" \
  ]