FROM centos:7
MAINTAINER Takashi Okawa <Takashi.Okawa@microsoft.com>

# add nginx repositry
COPY ./nginx/nginx.repo /etc/yum.repos.d/nginx.repo

# copy nginx config files
COPY ./nginx/nginx.conf /etc/nginx/nginx.conf
COPY ./nginx/virtualhost.conf /etc/nginx/conf.d/default.conf

# copy sample html file
COPY hostingstart.html /home/site/wwwroot/hostingstart.html

# copy sshd_config
COPY ./ssh/sshd_config /etc/ssh/

# copy entrypoint
COPY init_container.sh /bin/

# install packages
RUN set -x \
    && yum search nginx \
    && yum install -y nginx \
    && yum -y install iproute \
    && yum -y install openssh-server \
    && yum -y install less \
    && yum -y install curl \
    && yum -y install wget \
    && yum -y install tcptraceroute

# Apply Settings
RUN set -x \
    && rm -f /var/log/nginx/* \
    && chmod 777 /var/log \
    && chmod 777 /var/run \
    && chmod 777 /var/lock \
    && chmod 777 /bin/init_container.sh \
    && echo "root:Docker!" | chpasswd \
    && mkdir -p /home/site/wwwroot \
    && mkdir -p /home/LogFiles \
    && rm -rf /usr/share/nginx/html \
    && rm -rf /var/log/nginx \
    && ln -s /home/site/wwwroot /usr/share/nginx/html \
    && ln -s /home/LogFiles /var/log/nginx 

# set aliases
RUN echo 'alias ll='\''ls -laF'\' >> ~/.bashrc

EXPOSE 2222 80

ENTRYPOINT ["/bin/init_container.sh"]
