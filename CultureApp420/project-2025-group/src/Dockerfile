# Use the official Python runtime image
FROM python:3.13

# Create the app directory
RUN mkdir /app

# Set the working directory inside the container
WORKDIR /app

# Set environment variables
# Prevents Python from writing pyc files to disk
ENV PYTHONDONTWRITEBYTECODE=1
#Prevents Python from buffering stdout and stderr
ENV PYTHONUNBUFFERED=1

# Upgrade pip
RUN pip install --upgrade pip
RUN apt-get update && apt-get install -y --no-install-recommends curl openssh-client sshpass && rm -rf /var/lib/apt/lists/*
# Copy the Django project  and install dependencies
COPY requirements.txt  /app/

# run this command to install all dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the Django project to the container
COPY . /app/

# Create directories for static and media files
RUN mkdir -p /app/static /app/media

# Collect static files
RUN python manage.py collectstatic --noinput --clear

# Expose the Django port
EXPOSE 8000

# Run gunicorn server
CMD ["gunicorn", "--bind", "0.0.0.0:8001", "--workers", "3", "fa_app.wsgi:application"]