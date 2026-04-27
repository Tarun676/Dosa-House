# Stage 1: Build Image
FROM node:18-alpine AS builder

# Set working directory
WORKDIR /app

# Copy all project files into the image
COPY . .

# Run the custom build script to generate the 'dist' folder
RUN node scripts/build.js

# Stage 2: Production Server (Nginx)
FROM nginx:alpine

# Remove default nginx static assets
RUN rm -rf /usr/share/nginx/html/*

# Copy the static website artifacts from the builder stage
COPY --from=builder /app/dist /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Nginx starts automatically
CMD ["nginx", "-g", "daemon off;"]
