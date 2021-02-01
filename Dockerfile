FROM centos:7
MAINTAINER Takashi Okawa <Takashi.Okawa@microsoft.com>

# add nginx repositry
COPY ./nginx/nginx.repo /etc/yum.repos.d/nginx.repo

# copy nginx config files
COPY ./nginx/nginx.conf /etc/nginx/nginx.conf
COPY ./nginx/virtualhost.conf /etc/nginx/conf.d/default.conf

# copy sshd_config
COPY ./ssh/sshd_config /etc/ssh/

# copy entrypoint
COPY init_container.sh /bin/

RUN set -x \
    && yum search nginx \
    && yum install -y nginx \
    && yum -y install iproute \
    && yum -y install openssh-server \
    && chmod 755 /bin/init_container.sh \
    && echo "root:Docker!" | chpasswd \
    && yum -y install less \
    && yum -y install curl \
    && yum -y install wget \
    && yum -y install tcptraceroute
    
EXPOSE 2222 80

ENTRYPOINT ["/bin/init_container.sh"]
