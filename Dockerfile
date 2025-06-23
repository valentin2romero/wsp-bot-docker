# Stage 1: build the TypeScript/JavaScript source
FROM node:18-alpine AS build
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install
COPY . .
# Run the build script (assumes a "build" script in package.json)
RUN npm run build

# Stage 2: production/runtime image
FROM node:18-alpine AS production
WORKDIR /usr/src/app
# Copy only production dependencies
COPY package*.json ./
RUN npm ci --only=production
# Copy built output
COPY --from=build /usr/src/app/dist ./dist

# Copy any other assets if needed (e.g., public folder)
# COPY --from=build /usr/src/app/public ./public

# Default environment
ARG NODE_ENV=production
ENV NODE_ENV=${NODE_ENV}
ENV PORT=3008

# Expose port
EXPOSE 3008

# Default command: runs the "start" script (should be defined in package.json)
CMD ["npm", "run", "start"]