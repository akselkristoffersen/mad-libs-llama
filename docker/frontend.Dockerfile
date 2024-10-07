FROM node:22-alpine AS builder
WORKDIR /app
COPY frontend/package*.json .
RUN npm ci
COPY frontend .
RUN npm run build
RUN npm prune --production

FROM node:22-alpine
WORKDIR /app
COPY --from=builder /app/build build/
COPY frontend/package.json .
EXPOSE 3000
ENV NODE_ENV=production
CMD [ "node", "build" ]