B"H

Clone https://github.com/smuel1414/FCC-Basic-Node-and-Express.git
(A simple nodejs exercise project that i did a while ego)

Add unit testing (not actually related to the project)
Add unit testing to package.json scripts `npm test`.
Make sure `npm start` will start the project.
Add kubernetes health endpoint.

Add alpine `Dockerfile` with separate layers for fatching dependencies `npm install` and the build.
Add `Dockerfile.base` to add image dependencies (Save time in builds).

Build the base image: `docker build -t myapp-node-base:1.0.0 . -f Dockerfile.base`
Push the base image to dockerhub.

Make sure the app is running localy with docker.
```bash
docker build -t myapp-node-base:1.0.0 .
docker run --rm -it --name myapp-debug -p 3333:3000 myapp-node-base:1.0.0
```

Create new helm chart.
Add replace strings for changing values in `values.yaml`
Create install script with app spesific values that replace place holders with real values.
Create docker build script.