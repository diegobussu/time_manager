FROM node:22 AS build-stage

WORKDIR /app

COPY package*.json ./

RUN npm install --force

COPY . .

RUN mv .env.prod .env

RUN npm run build

FROM nginx:alpine

COPY --from=build-stage /app/dist /usr/share/nginx/html

# Renommer le fichier de configuration Nginx par défaut
RUN mv /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.disabled

# Copier le fichier de configuration Nginx personnalisé
COPY default.conf /etc/nginx/conf.d/default.conf
 

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]