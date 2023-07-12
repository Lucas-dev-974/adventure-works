# app/Dockerfile

FROM python:3.9-slim

WORKDIR /app

RUN apt-get update && apt-get install -y \
    build-essential \
    libgl1-mesa-glx \
    curl \
    software-properties-common \
    git \
    && rm -rf /var/lib/apt/lists/*

#Install ODBC
RUN apt-get -y update && apt-get install -y curl gnupg

RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -

# download appropriate package for the OS version
# Debian 11
RUN curl https://packages.microsoft.com/config/debian/11/prod.list  \
    > /etc/apt/sources.list.d/mssql-release.list

RUN exit
RUN apt-get -y update
RUN ACCEPT_EULA=Y apt-get install -y msodbcsql18
# ------------------------

RUN git clone https://github.com/Lucas-dev-974/adventure-works.git .

RUN pip3 install -r requirements.txt

EXPOSE 8501

HEALTHCHECK CMD curl --fail http://localhost:8501/_stcore/health

ENTRYPOINT ["streamlit", "run", "main.py", "--server.port=8501", "--server.address=0.0.0.0"]