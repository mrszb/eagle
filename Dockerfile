FROM ubuntu:18.04

#ENV TZ=Europe/Bratislava
#RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
#ENV DEBIAN_FRONTEND=noninteractive

ENV eagle_ver=9.6.2

#RUN  apt-get update \
#    && apt-get upgrade -y 

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        #tzdata \
        wget bzip2 
  #  && rm -rf /var/lib/apt/lists/*

RUN adduser --gecos 'User Name,,,' --disabled-password user
RUN wget -q -O /tmp/eagle.tar.gz http://eagle-updates.circuits.io/downloads/9_6_2/Autodesk_EAGLE_${eagle_ver}_English_Linux_64bit.tar.gz

RUN mkdir -p /opt/eagle-${eagle_ver}
RUN chown user:user /opt/eagle-${eagle_ver}

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        libnss3 xterm x11-apps \
        glib2.0 mesa-utils and libgl1-mesa-glx libxrandr2 libasound2

# solving:
# terminate called after throwing an instance of 'std::runtime_error'
#  what():  locale::facet::_S_create_c_locale name not valid

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends locales tzdata #firefox
RUN locale-gen en_US.UTF-8 && update-locale LANG=en_US.UTF-8

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends dbus
RUN dbus-uuidgen > /var/lib/dbus/machine-id

USER user
WORKDIR /opt
RUN tar zxpf /tmp/eagle.tar.gz

USER root
RUN rm /tmp/eagle.tar.gz

USER user
RUN mkdir /home/user/eagle
WORKDIR /home/user
ADD start.sh .
#RUN chmod +x ./start.sh

ENV DISPLAY=host.docker.internal:0.0
CMD ["/home/user/start.sh"]



