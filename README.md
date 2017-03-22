# nanoc blog in docker

## Build

$ docker build -t bmantay/nanoc .

## Run for Development

Here my local code is mounted inside the container. We override the CMD in the Dockerfile to call `bundle exec nanoc live` which starts the nanoc-gaurd gem watching for changes so it can automatically re-build.

```
$ docker run -d -p 3000:3000 -v /home/osboxes/code/nanoc:/usr/src/app bmantay/nanoc bundle exec nanoc live
```

## Run 

```
$ docker run -d -p 3000:3000 bmantay/nanoc
```

## View

http://localhost:3000
