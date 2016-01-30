FROM centos:7

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

MAINTAINER okasho <okasho1010@gmail.com>

RUN echo "install ruby environment"
RUN yum install -y git vim sudo tar wget

RUN yum install -y epel-release
RUN yum install -y gcc-c++ git glibc-headers libffi-devel libxml3 libxml2-devel libxslt libxslt-devel libyaml-devel make nodejs npm openssl-devel readline readline-devel sqlite-devel zlib zlib-devel

## Ruby
RUN cd /usr/local/src && \
  wget http://cache.ruby-lang.org/pub/ruby/2.2/ruby-2.2.2.tar.gz && \
  tar zxvf ruby-2.2.2.tar.gz && \
  cd ruby-2.2.2 && \
  ./configure --disable-install-doc && \
  make && \
  make install
RUN echo 'gem: --no-document' > /usr/local/etc/gemrc
RUN yum install -y patch
RUN gem update --system


RUN yum install -y crontabs
RUN cp -p  /usr/share/zoneinfo/Japan /etc/localtime

#lib/task/morning.rb -> EDIT!!!!!!!!
RUN yum -y install mysql-server mysql-devel

RUN git clone https://okamuroshogo:Okasho1010@github.com/planningdev/kyutechapp.git
#RUN git clone -b feature_silbus https://okamuroshogo:Okasho1010@github.com/planningdev/kyutechapp.git
WORKDIR /kyutechapp

RUN gem install bundler
RUN gem install nokogiri -- --use-system-libraries=true --with-xml2-include=/usr/include/libxml2/
RUN bundle config build.nokogiri --use-system-libraries

RUN bundle install --path vendor/bundle
RUN bundle config --global path 'vendor/bundle'

RUN touch .env
RUN echo SECRET_KEY=`rake secret` > .env

#selenium
RUN yum -y install xorg-x11-server-Xvfb
RUN yum -y install firefox
RUN dbus-uuidgen > /var/lib/dbus/machine-id
#RUN echo "export DISPLAY=:1" >> ~/.bash_profile
#RUN Xvfb :1 &

########                                                                                                                                                                               
                                                                                                                                                                                       
ADD ./cron/etc/cron.sh /root/cron.sh                                                                                                                                                   
ADD ./cron/etc/morning.sh /root/morning.sh                                                                                                                                             
RUN chmod 775 /root/cron.sh                                                                                                                                                            
RUN chmod 775 /root/morning.sh                                                                                                                                                         
RUN touch log/cron.log                                                                                                                                                                 
RUN touch log/morning.log                                                                                                                                                              
RUN bundle exec whenever --update-crontab                                                                                                                                              
                                                                                                                                                                                       
ADD ./cron/bin/start-cron.sh /usr/bin/start-cron.sh                                                                                                                                    
RUN touch /var/log/cron.log                                                                                                                                                            
RUN chmod 775 /usr/bin/start-cron.sh                                                                                                                                                   
RUN sh /usr/bin/start-cron.sh                                                                                                                                                          
                                                                                                                                                                                       
RUN chmod 775 /root/env.sh                                                                                                                                                             
ADD ./cron/etc/crontab /var/spool/cron/root             

ENV RAILS_ENV production

