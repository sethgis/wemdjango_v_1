# Use an official Python runtime as a parent image
FROM python:3.8.5

LABEL maintainer="snyawacha@gmail.com"
LABEL description="Geo-API achitecture"


RUN apt-get update \
    && apt-get install -y binutils libproj-dev gdal-bin python-gdal python3-gdal    





RUN apt-get update && apt-get install -y gdal-bin \
     apt-utils libgdal-dev
# install dependencies
RUN apt-get update && \
    apt-get install -y gcc python3-dev musl-dev \
    gdal-bin \
    libgeos-dev \
    libffi-dev \
    proj-bin \
    libopenblas-dev \ 
    python3-scipy python3-numpy python3-pandas \
    netcat \
    nano

RUN apt-get update && apt-get install -y gdal-bin \
     apt-utils libgdal-dev

# COPY ./requirements.txt /app/requirements.txt



# Run this to install geoserver-rest dependencies
RUN pip install pygdal=="`gdal-config --version`.*"
# RUN pip install pygdal==2.4.2.10

RUN pip install -I GDAL=="`gdal-config --version`.*"

# Set environment variables for Python
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Create and set the working directory
WORKDIR /app

# Copy the requirements file into the container at /app
COPY requirements.txt /app/

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Copy the current directory contents into the container at /app
COPY . /app/

# Collect static files
RUN python manage.py collectstatic --noinput

# Set the default command to run when the container starts
CMD ["gunicorn", "geodjango.wsgi:application", "--bind", "0.0.0.0:8005"]
