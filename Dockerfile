# build stage
FROM node:13-alpine as build-stage
WORKDIR /app
COPY . .
RUN npm install --no-package-lock
RUN npm run build

# production stage
FROM nginx:1.17-alpine as production-stage
# mặc định khi run vueJs sẽ tạo ra 1 thư mục dist
# copy folder /app/dist từ build-stage đến /usr/share/nginx/html
COPY --from=build-stage /app/dist /usr/share/nginx/html
CMD ["nginx", "-g", "daemon off;"]
