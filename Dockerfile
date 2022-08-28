FROM mongo:4.2.2

RUN apt update
RUN apt-get install -y wget curl unzip nano

COPY . .

WORKDIR /home/fynd-data

RUN chmod +x setup_db.sh

RUN echo "Finished"