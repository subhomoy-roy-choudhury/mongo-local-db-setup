echo "Creating database folder :-";

mkdir database

echo "Building and starting mongo:4.2.2 instance"
docker-compose up --build -d

echo "Finished"