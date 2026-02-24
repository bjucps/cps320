# Containerizes the Django app for consistent local dev and future deployment.
# Build context is the repo root; requirements are installed first for caching.

FROM python:3.11-slim

# Set environment variables for Python
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Create the working directory
WORKDIR /app

# Install system dependencies (needed for psycopg2/Postgres)
RUN apt-get update && apt-get install -y \
    libpq-dev gcc && \
    apt-get clean

# Copy requirements first
COPY requirements.txt /app/

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy into container
COPY . /app/

# Expose the port Django runs on
EXPOSE 8000

# Run migrations and then start Django’s development server
CMD ["sh", "-c", "python manage.py migrate && python manage.py runserver 0.0.0.0:8000"]