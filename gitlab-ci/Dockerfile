FROM node:26.8.1-alpine3.24

RUN mkdir -p /app

WORKDIR /app

RUN apk upgrade --no-cache && apk add --no-cache tzdata nginx git openssl

ENV TZ="Asia/Jakarta"

RUN cp /usr/share/zoneinfo/Asia/Jakarta /etc/localtime

COPY package.json /app/

# npm is needed only to install PM2 and pnpm. Remove it afterwards so its
# bundled dependencies are not present in the production image.
RUN npm install pm2 pnpm@12.3.4 -g \
    && npm cache clean --force \
    && rm -rf /usr/local/lib/node_modules/npm \
    && rm -f /usr/local/bin/npm /usr/local/bin/npx

RUN mkdir -p /app/Upload/Files

COPY . /app

RUN pnpm install --frozen-lockfile --prod

EXPOSE 3000

CMD ["pm2-runtime", "index.js"]