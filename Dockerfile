FROM python:3.7-buster

# set work directory
WORKDIR /app

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Install dependencies (sin dnsutils ni libpq-dev)
RUN apt-get update && apt-get install --no-install-recommends -y \
    python3-dev=3.7.3-1 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install vulnerable Python dependencies
RUN python -m pip install --no-cache-dir pip==22.0.4
COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Copy project
COPY . /app/

# Expose port (si Scout lo necesita)
EXPOSE 8000

# Dejar la imagen lista para análisis sin ejecutar la app
CMD ["sleep", "3600"]
