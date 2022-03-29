FROM node:10.9.0-alpine

# Create app directory
WORKDIR /app
COPY package*.json ./
RUN npm install -g nodemon
RUN npm install
COPY . /app
CMD ["nodemon", "server.js"]