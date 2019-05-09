Docker RServe
===

Provides a container to allow the user to spring up an RServe service quickly. Based on the [R-Base](https://hub.docker.com/_/r-base/) official community container.

Docker Compose: edit the compose.env file to add your own username and password that rserve will use for authentication. Otherwise, the username and password will be `rserve`. The container can be sprung up by executing `docker-compose up`

If using plain Docker, the simplest way to run is:

`docker run -p 6311:6311 fixiu/r-serve[:TAG]`

If you wish to use your own username and password:

`docker run  -e USERNAME=<username> -e PASSWORD=<password> -p 6311:6311 fixiu/r-serve`

The RServe Docker container provides its services on the exposed port `6311`.

There is a [health check](https://docs.docker.com/engine/reference/builder/#/healthcheck) on the container which tests whether RServe is up by attempting to connect to it.
