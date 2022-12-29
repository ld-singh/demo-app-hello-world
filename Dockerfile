# stage 1
FROM node:16.19.0-bullseye-slim AS base

WORKDIR /base
# Add package-lock.json
COPY package.json .
COPY package-lock.json .

# USe npm ci to use package-lock.json and --omit=dev to install production only dependencies
RUN npm ci --omit=dev

# stage 2

FROM gcr.io/distroless/nodejs16-debian11:nonroot

USER nonroot

WORKDIR /usr/src/app

COPY --chown=nonroot:nonroot . .

COPY --chown=nonroot:nonroot --from=base /base/node_modules ./node_modules

EXPOSE 3000

CMD ["index.js"]

