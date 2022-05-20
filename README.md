# Docker VueJs

1. Cài đặt
    1. Dockerfile
        
        ```bash
        # build stage
        FROM node:13-alpine as build-stage
        WORKDIR /app
        COPY . .
        RUN npm install
        RUN npm run build
        
        # production stage
        FROM nginx:1.17-alpine as production-stage
        # mặc định khi run vueJs sẽ tạo ra 1 thư mục dist
        # copy folder /app/dist từ build-stage đến /usr/share/nginx/html
        COPY --from=build-stage /app/dist /usr/share/nginx/html
        CMD ["nginx", "-g", "daemon off;"]
        ```
        
    2. build image
        
        ```bash
        $ docker build -t learning-docker/docker-vuejs:v1 .
        ```
        
    3. docker-compose.yml
        
        ```bash
        version: "3.7"
        
        services:
          vuejs-app:
            image: learning-docker/docker-vuejs:v1
            ports:
              - "5000:80"
            restart: unless-stopped
        ```
        
    4. run
        
        ```bash
        docker-compose up
        ```
        
2. Khác
    1. Chạy container tạm thời (intermediate container: container trung gian)
        
        ```bash
        # docker run --rm -v $(pwd):<WORKDIR> -w <WORKDIR> <IMAGE> <CMDs TO BUILD PROJECT>
        
        $ docker run --rm -v $(pwd):/app -w /app node:13-alpine npm install && npm run build
        ```
        
        ```bash
        --rm: tự xóa sau khi tạo ra container
        -v: volume, thuực hiện mount volume ở project máy thật vào workdir của container
        -w: workdir trong container
        node:13-alpine: tương đương với FROM:node:13-alpine
        npm install && npm run build: các command cần để build project
        ```
        
        - Lúc này sẽ thấy thư mục node_modules và dist vì mình đã mount volume
        - Khi mount volume, volume container phải là đường dẫn phải tuyệt đối.
    2. Tự động build project khi có thay đổi code ở phía máy thật.
        1. Dockerfile
            
            ```bash
            FROM node:12.18-alpine
            WORKDIR /app
            COPY . .
            RUN npm install
            # lắng nghe sự kiện thay đổi code trong workdir
            CMD ["npm", "run", "serve"]
            ```
            
        2. docker-compose.yml
            
            ```bash
            version: "3.4"
            
            services:
              app:
                image: learning-docker/docker-vuejs:v2
                volumes:
                  - ./src:/app/src
                ports:
                  - "5000:8080"
                restart: unless-stopped
            ```
            
3. Tài liệu tham khảo
    1. [https://viblo.asia/p/dockerize-ung-dung-vuejs-reactjs-ORNZqxwNK0n](https://viblo.asia/p/dockerize-ung-dung-vuejs-reactjs-ORNZqxwNK0n)