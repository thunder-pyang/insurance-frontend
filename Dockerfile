FROM node:14-alpine as BUILDER
RUN npm install -g pnpm
WORKDIR /app
COPY package.json pnpm-lock.yaml /app/
RUN pnpm install
COPY . .
RUN pnpm build

FROM nginx
COPY variableReplace.sh /docker-entrypoint.d/
COPY --from=BUILDER /app/dist /usr/share/nginx/html
COPY .env /usr/share/nginx/html
RUN chgrp -R 0 /etc/nginx/conf.d && chmod -R g=u /etc/nginx/conf.d
RUN chgrp -R 0 /usr/share/nginx/html && chmod -R g=u /usr/share/nginx/html
RUN chgrp -R 0 /var/cache/nginx && chmod -R g=u /var/cache/nginx

