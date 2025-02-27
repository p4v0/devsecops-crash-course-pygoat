FROM python:3.7-buster

# set work directory
WORKDIR /app

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Install pip and a known vulnerable package
RUN python -m pip install --no-cache-dir pip==22.0.4 flask==0.12.3

# Keep the container alive for scanning
CMD ["sleep", "3600"]
