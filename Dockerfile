# Install the app dependencies in a full Node docker image
FROM registry.access.redhat.com/ubi10/nodejs-22:latest

# Copy package.json, and optionally package-lock.json if it exists
COPY package.json package-lock.json* ./

# Install app dependencies
RUN \
  if [ -f package-lock.json ]; then npm ci; \
  else npm install; \
  fi

# Copy the dependencies into a Slim Node docker image
FROM registry.access.redhat.com/ubi10/nodejs-22-minimal:latest

# Include licences
COPY LICENSE /licenses/LICENSE

# Install app dependencies
COPY --from=0 /opt/app-root/src/node_modules /opt/app-root/src/node_modules
COPY . /opt/app-root/src

# Set these labels not to inherit from parent container
LABEL com.redhat.component="nodejs-devfile-sample"
LABEL description="Description of nodejs-devfile-sample"
LABEL io.k8s.description="Description of nodejs-devfile-sample"
LABEL io.k8s.display-name="nodejs-devfile-sample"
LABEL io.openshift.tags="perfscaletest"
LABEL name="nodejs-devfile-sample"
LABEL summary="Summary of nodejs-devfile-sample"

ENV NODE_ENV production
ENV PORT 3001

CMD ["npm", "start"]
