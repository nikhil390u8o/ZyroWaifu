FROM python:3.8.5-slim-buster

ENV PIP_NO_CACHE_DIR=1
ENV BOT_TOKEN=7392456702:AAEkFumYEFLORrOiCw9sgpndE74RyQcMEu8
ENV CHAT_ID=-1002465116955

# Install dependencies (wkhtmltopdf is not in buster repo, so install from .deb)
RUN apt-get update && apt-get install -y \
    curl \
    libxrender1 \
    libxext6 \
    fontconfig \
 && curl -L https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6-1/wkhtmltox_0.12.6-1.buster_amd64.deb -o wkhtml.deb \
 && apt-get install -y ./wkhtml.deb \
 && rm wkhtml.deb \
 && apt-get clean && rm -rf /var/lib/apt/lists/*

# Upgrade pip and setuptools
RUN pip3 install --upgrade pip setuptools

# Copy application code
COPY . /app/
WORKDIR /app/

# Install Python dependencies
RUN pip3 install --no-cache-dir -U -r requirements.txt

# Add entrypoint script to send Telegram startup message at container run
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["python3", "-m", "TEAMZYRO"]
