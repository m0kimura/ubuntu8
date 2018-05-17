FROM ubuntu:18.04

ARG node=${node:-8.11.2}
ENV LANG=ja_JP.UTF-8 LC_ALL=ja_JP.UTF-8 LC_CTYPE=ja_JP.UTF-8 TZ=JST-9

##  ON BUILD USER
ONBUILD ARG user=${user:-docker}
ONBUILD RUN \
    export uid=1000 gid=1000 && \
    mkdir -p /home/${user} && \
    echo "${user}:x:${uid}:${gid}:${user},,,:/home/${user}:/bin/bash" >> /etc/passwd && \
    echo "${user}:x:${uid}:" >> /etc/group && \
    echo "${user} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/${user} && \
    chmod 0440 /etc/sudoers.d/${user} && \
    chown ${uid}:${gid} -R /home/${user}
##

RUN apt-get update \
##  UBUTNTU JAPANESE SETTING
&&  echo "### ub-japanese ###" \
&&  apt-get install -y language-pack-ja-base language-pack-ja \
    fonts-takao-mincho fonts-takao \
&&  update-locale LANG=ja_JP.UTF-8 LANGUAGE="ja_JP:ja" \
&&  /bin/bash -c 'source /etc/default/locale' \
##
##  UBUNTU BASE 8.3.0
&&  echo "### ub-base ###" \
&&  apt-get install -y sudo software-properties-common wget curl \
&&  apt-get install -y nano git nodejs npm \
&&  npm cache clean \
&&  npm install n -g \
&&  n ${node} \
&&  ln -sf /usr/local/bin/node /usr/bin/node \
##
&&  apt-get clean \
&&  rm -rf /var/lib/apt/lists/*

cmd /bin/bash
