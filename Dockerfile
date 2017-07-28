## Modified by Sam KUON - 28/05/17
FROM centos:latest
MAINTAINER Sam KUON "sam.kuonssp@gmail.com"

# System timezone
Env TZ=Asia/Phnom_Penh
Run ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install repositories & Nginx packages
RUN echo $'[nginx]\n\
name=nginx repo\n\
baseurl=http://nginx.org/packages/centos/$releasever/$basearch/\n\
gpgcheck=0\n\
enabled=1\n'\
> /etc/yum.repos.d/nginx.repo
RUN yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && \
    yum clean all && \
    yum -y update && \
    yum -y install nginx

# System configurations
RUN adduser --system --no-create-home --user-group -s /sbin/nologin -u 48 apache
RUN mkdir /etc/nginx/sites-enabled && \
    mkdir /srv/www && \
    mkdir /etc/nginx/global-conf.d && \
    chown -R apache:apache /srv/www
COPY ./nginx.conf /etc/nginx/nginx.conf
COPY ./webhost.conf /etc/nginx/sites-enabled/webhost.conf
RUN chmod 555 /etc/nginx/{nginx.conf,/sites-enabled/webhost.conf}

# Listen ports
EXPOSE 80

# NGINX auto startup
STOPSIGNAL SIGTERM
CMD ["nginx", "-g", "daemon off;"]
