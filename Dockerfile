FROM node:8.16.0-alpine

#sudo docker build -t securl .
#sudo docker run -p 3000:3000 -i -t securl

WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .

CMD [ "npm", "start" ]
