						 
FROM python:3.7-buster

# set work directory
WORKDIR /app

# Agregar repositorio de Snapshots para paquetes antiguos
RUN echo "deb http://snapshot.debian.org/archive/debian/20220910T000000Z buster main" > /etc/apt/sources.list \
    && echo "Acquire::Check-Valid-Until false;" > /etc/apt/apt.conf.d/99no-check-valid-until

# Actualizar e instalar paquetes vulnerables
RUN apt-get update && apt-get install --no-install-recommends -y \
    dnsutils=1:9.11.5.P4+dfsg-5.1+deb10u9 \
    libpq-dev=11.16-0+deb10u1 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*


# Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1


# Install dependencies
RUN python -m pip install --no-cache-dir pip==22.0.4
COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt


# copy project
COPY . /app/


# install pygoat
EXPOSE 8000


RUN python3 /app/manage.py migrate
WORKDIR /app/pygoat/
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "--workers","6", "pygoat.wsgi"]
