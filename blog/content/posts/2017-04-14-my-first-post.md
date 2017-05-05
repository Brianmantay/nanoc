---
title: "Containerized nanoc"
created_at: 2017-04-14 09:00:00 +0000
kind: article
---


Probably like many of my kind I've thought having a blog would be nice but have never bothered. I'm not really one for self promotion in that sense, but I'm feeling inspired...

I wanted to tinker with Docker to containerize a Nanoc blog. More just to step through some basic Docker stuff and follow through with a basic CI/CD pipline, simply for the sake of it.

**Goals:**

1. Create a blog in a container as an excuse to use Docker

2. Develop inside my container

3. When I commit changes my container will be deployed

##Set up nanoc

For this I fired up an Ubuntu VM and installed Docker as per the [Docker site instructions](https://docs.docker.com/engine/installation/linux/ubuntu/). I then set about [getting nanoc installed](https://nanoc.ws/doc/tutorial/)

In my case I generated a new site and created the following Gemfile

    source 'https://rubygems.org'
    gem 'nanoc'
    gem 'kramdown'
    gem 'adsf'
    gem 'compass'
    gem 'compass-h5bp'

After a trusty 

    $ bundle install

and a

    $ nanoc view

I had things running with the default site on localhost:3000

##Ramming it inside Docker

There are easier ways to host nanoc sites... but I wanted to containerize. I created my Dockerfile, and after a bit of trial and error I settled for

    FROM ruby:2.3				// gives me a base ruby image to work from (cheers) 
    RUN mkdir -p /user/src/app		// creates my target code directory inside the container
    COPY . /usr/src/app			// takes my source and puts it there
    WORKDIR /usr/src/app/blog		// sets the context for which commands will be run inside the container
    EXPOSE 3000				// exposeds a container port to the host
    RUN bundle install			// will occur when the container is created, so my Gemfile dependencies are installed in the container
    CMD bundle exec nanoc -v && bundle exec nanoc view	// the starts the nanoc site when the container starts

After a trusty 

    $ docker build -t bmantay/nanoc .

I had a built image from which my container instances can be created. Whatsmore:

    $ docker run -d -p 3000:3000 bmantay/nanoc

I had my nanoc site running inside my Docker container exposed on http://localhost:3000

Withstanding any meanful content... that's pretty much my blog in a container ready for deployment.

I have of course been committing this [my Git repo](https://github.com/Brianmantay/nanoc)

##My dev environment

I'm curious about the jouney of a container from dev to prod. So I felt I wanted to ensure I'm developing the blog and its content inside the container. So for development I want 1) changes made on my local machine to be reflected inside the container... 2) nanoc to recompile when I make changes so I dont have to run 'nanoc view' inside the container evey change I make.

For the recompile on changes a common solution is to install the Guard gem. I added this to my Gemfile and created the following Guard file... it basically watches for changes on the file system and triggers a nanoc compilation:

    guard 'nanoc' do
      watch('nanoc.yaml')
      watch('Rules')
      watch(%r{^(content|layouts|lib)/.*$})
    end

With this you can now kick the site off with the 'nanoc live' instead of 'nanoc view'

To allow my changes to be reflected in the container however, I need to map a volume from my local dev to the container. This is achieved using the -v option. So I mapped my local directory home/osboxes/code/nanoc to the container /usr/src/app (specified in thte Dockerfile earlier)

I also learned you can overwrite the CMD in the Dockerfile at runtime. This allowed me to fire up Guard so my changes in the volume trigger a recompile. So, when I'm developing I can start my container like this:
 
    $ docker run -d -p 3000:3000 -v /home/osboxes/code/nanoc:/usr/src/app bmantay/nanoc bundle exec nanoc live

Took a bit a fiddling around but I was pleased :)

##Sum up
I've achieved 2 of my 3 goals so far. Number 3 (the container deployment) will have to wait for part 2.



