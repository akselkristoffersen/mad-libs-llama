FROM node:22-alpine AS builder
WORKDIR /app
COPY frontend/package.json frontend/package-lock.json ./
RUN npm ci
ARG VITE_API_URL
RUN if [ -z "$VITE_API_URL" ]; then \
      echo "Error: VITE_API_URL must be set." && exit 1; \
    fi
ENV VITE_API_URL=$VITE_API_URL
COPY frontend .
RUN npm run build

FROM nginx:alpine
COPY --from=builder /app/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]