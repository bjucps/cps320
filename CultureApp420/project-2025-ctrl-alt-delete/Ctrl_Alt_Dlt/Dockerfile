FROM python:3.13-slim AS builder

WORKDIR /app
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Upgrade pip and build tools
RUN pip install --upgrade pip setuptools wheel

# System dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    libjpeg-dev \
    zlib1g-dev \
    libffi-dev \
    libssl-dev \
    sqlite3 \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements and install
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy your entire project
COPY . .

# --- IMPORTANT FIXES ---
# Ensure the entrypoint file is in the image
COPY entrypoint.prod.sh /app/

# Convert CRLF → LF **if using Windows**
RUN sed -i 's/\r$//' /app/entrypoint.prod.sh

# Make it executable
RUN chmod +x /app/entrypoint.prod.sh

EXPOSE 8000

CMD ["/app/entrypoint.prod.sh"]
