FROM postgres:12

RUN apt-get update && \
    apt install -y git python3 python3-pip vim && \
    ln -s /usr/bin/python3.7 /usr/bin/python && \
    ln -s /usr/bin/pip3 /usr/bin/pip

RUN cd /home && \
    git clone https://github.com/uw-advanced-robotics/imagetagger.git && \
    cd imagetagger && \
    git checkout c0e335e0c1cea4b14c6c831fa8e5720a099d7ffb && \
    pip3 install -r requirements.txt

COPY settings.py /home/imagetagger/imagetagger/imagetagger/settings.py

RUN pg_createcluster 12 main 

RUN sed -i 's/local   all             postgres                                peer/     local   all             postgres                                trust/' /etc/postgresql/12/main/pg_hba.conf && \
    /etc/init.d/postgresql start &&\
    cat /etc/postgresql/12/main/pg_hba.conf &&\
    psql -U postgres --command "CREATE USER imagetagger PASSWORD 'imagetagger';" &&\
    psql -U postgres --command "CREATE DATABASE imagetagger WITH OWNER imagetagger ENCODING UTF8;" &&\
    sed -i 's/local   all             postgres                                trust/local   all             postgres                                peer/' /etc/postgresql/12/main/pg_hba.conf

RUN /etc/init.d/postgresql start &&\
    /home/imagetagger/imagetagger/manage.py migrate &&\
    echo "from django.contrib.auth import get_user_model; User = get_user_model(); User.objects.create_superuser('admin', 'robomstr@uw.edu', 'password')" | /home/imagetagger/imagetagger/manage.py shell

#/home/imagetagger/imagetagger/manage.py createsuperuser 

EXPOSE 8000

CMD /etc/init.d/postgresql start &&\
    /home/imagetagger/imagetagger/manage.py runserver 0.0.0.0:8000
