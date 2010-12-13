Bob (the Builder)
=================

BOB (the builder) was written becaus I wanted to experience writing an
open source application.  BigTuna recently came out which is a great CI
as well, and I liked many of the things they had done. Some of that can
also be seen here in BOB but slightly different. We have now switched to
BOB at work and it is running builds on 3 different applications
conistently, with no issues. 

Currently this code is being used but is in its very early stages.  I
would consider this a working alpha. As soon as I let BOB run for a
couple weeks I will release it as a production release once I am certain
major bugs are not in the code.

Currently the code is tested on REE 1.8.7(-head) & 1.9.2-p0.


In the works
------------

I am currently working on better management for the builds & build
steps. Including multiple builds & build steps per project to organize
your builds a little better. I am also working on a hook system to allow
for more flexibility at each step of the build process.


Thanks
------

I want to thank the guys who wrote BigTuna, CIJoe, Signal, Integrity
etc., because not only did you guys inspire me to write my own, but
looking through your code taught me a lot.  I still have a lot more to
learn but it was a great learning experience for me. 

Setup
-----

1. Clone the repository.
2. Modify config/mongoid.yml to your liking. (Make sure to set
   Environment vars for production user, pass, host, database name.
3. Copy config/app_config.yml.sample & config/mongoid.yml.sample to config/app_config.yml
   and config/mongoid.yml and modify to setup your domains.
4. Set up your nginx, apache, thin etc. server for the CI codebase. 
5. Run `rake db:seed` to setup the default admin user (admin@test.com /
   123456)
6. Run delayed job. `RAILS_ENV=production script/delayed_job -n 2 start` 

From here just go into the web interface and add a new project. You can
create as many build steps as you wish and keep each step organized a
little nicer.  

RVM
--- 

If you use rvm and maintain an .rvmrc in your project directory, BOB
will automatically source this file so you don't have to source it in
your build steps.

Otherwise to run the build in a specific environment, you can do
something like the following in one of your first build steps:  `source /home/user/.rvm/environments/ruby@gemset`

.bobrc
------

If for whatever reason you need to run some commands but don't want them
to show up in your build steps, you can add them to a .bobrc file and it
will be automatically sourced.  

Notifications
-------------

Right now the only notifications BOB offers is Campfire although more
will be added frequently. Being that we use this tool at work, in a real
environment you can bet that changes to the code will come frequently as
we encounter bugs.

Services
--------

Right now you can send post-commit hooks from GitHub to BOB. You can
post to http://example.com/service/:project_id/github


SCM's
-----

At the moment Git is the only SCM supported but we also use mercurial at
work, so expect it to be supported in the very near future.

Screenshots
===========


Dashboard Page
--------------

![Dashboard](http://files.droplr.com/files/59183674/ztsC.Screen%20shot%202010-12-04%20at%2013%3A37%3A27.png)

Project Page
------------

![Project
Page](http://files.droplr.com/files/59183674/mItg.Screen%20shot%202010-12-04%20at%2013%3A38%3A41.png)

Sample Build Step Output
------------------------

![Sample Build Step Output](http://files.droplr.com/files/59183674/NtiU.Screen%20shot%202010-12-04%20at%2013%3A39%3A40.png)
