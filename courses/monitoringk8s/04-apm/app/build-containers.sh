cd frontend/ && docker build -t frontend-service:latest . && cd ..
cd node-api/ && docker build -t node-api:latest . && cd ..
cd sensors/ && docker build -t sensors-api . && cd ..
cd pumps/ && docker build -t pumps-service:latest . && cd ..
