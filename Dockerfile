FROM postgres:12

RUN apt-get update && \
    apt install -y git python3 python3-pip vim && \
    ln -s /usr/bin/python3.7 /usr/bin/python && \
    ln -s /usr/bin/pip3 /usr/bin/pip

COPY requirements.txt /home/
RUN pip3 install -r /home/requirements.txt

RUN pg_createcluster 12 main 

RUN sed -i 's/local   all             postgres                                peer/     local   all             postgres                                trust/' /etc/postgresql/12/main/pg_hba.conf && \
    /etc/init.d/postgresql start &&\
    cat /etc/postgresql/12/main/pg_hba.conf &&\
    psql -U postgres --command "CREATE USER imagetagger PASSWORD 'imagetagger';" &&\
    psql -U postgres --command "CREATE DATABASE imagetagger WITH OWNER imagetagger ENCODING UTF8;" &&\
    sed -i 's/local   all             postgres                                trust/local   all             postgres                                peer/' /etc/postgresql/12/main/pg_hba.conf

#/home/imagetagger/imagetagger/manage.py createsuperuser 
# RUN apt-get update &&\
#     apt-get install -y openssh-server

#change root pass & other config, delete keys (ssh entrypoint will generate on startup)
# RUN mkdir /var/run/sshd && \
#     echo 'root:root' | chpasswd && \
#     sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
#     mkdir /root/.ssh && \
#     apt-get clean && \
#     rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
#     rm -rf /etc/ssh/ssh_host_rsa_key /etc/ssh/ssh_host_dsa_key

# COPY scripts/scripts_docker-ssh-entrypoint.sh /usr/local/bin

COPY ./ /home/imagetagger/

#COPY imagetagger/imagetagger/settings.py /home/imagetagger/imagetagger/imagetagger/settings.py

RUN /etc/init.d/postgresql start &&\
    /home/imagetagger/imagetagger/manage.py migrate &&\
    echo "from django.contrib.auth import get_user_model; User = get_user_model(); User.objects.create_superuser('admin', 'robomstr@uw.edu', 'password')" | /home/imagetagger/imagetagger/manage.py shell

EXPOSE 8000

CMD /etc/init.d/postgresql start &&\
    /home/imagetagger/imagetagger/manage.py runserver 0.0.0.0:8000
    # scripts_docker-ssh-entrypoint.sh &&\
    # /usr/sbin/sshd -D

