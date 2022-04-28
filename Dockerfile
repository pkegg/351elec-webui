FROM ubuntu:22.04 as prod

RUN apt-get update \
    && apt-get install --no-install-recommends -y python3-pip libpam-systemd nginx vim
WORKDIR /usr/share/webui
ADD setup.py ./
RUN python3 setup.py install
ADD assets/ assets/
ADD build/ build/
ADD dist/ dist/
ADD views views/
ADD *.py ./
ADD nginx.conf /etc/nginx/sites-enabled/default

FROM prod as test

ADD test/root_dir/usr/config/emulationstation/ /usr/config/emulationstation/
RUN ls -lah /usr/share/webui
RUN useradd -ms /bin/bash newuser
RUN echo 'newuser:newpassword' | chpasswd

FROM prod