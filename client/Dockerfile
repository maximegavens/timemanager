FROM node:12
COPY . /client
WORKDIR /client

COPY . .
RUN npm install @vue/cli -g
RUN npm install
EXPOSE 8080
CMD ["npm", "run", "start"]
