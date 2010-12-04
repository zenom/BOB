Bob (the Builder)
=================

BOB is a tool I have wanted to write for sometime and the introduction
of BigTuna really pushed me to do it.  This is a build tool we use at
work now as most of the others were lacking features, or not being
maintained. This project was also used as a learning experience for me
to learn more about testing and CI.

Currently this code is being used but is in its very early stages.  I
would consider this a working alpha. As it is put into production and
used I will change this to a production release, I just want to get some
more testing under its belt.  

Thanks
------

I want to thank the guys who wrote BigTuna, CIJoe, Signal, Integrity
etc., because not only did you guys inspire me to write my own, but also
for open sourcing your code, so guys like me can learn and build his own
  CI tool. 

Setup
-----

1. Clone the repository.
2. Modify config/mongoid.yml to your liking.
3. Set it up via nginx, etc.
4. Run rake jobs:work

From here just go into the web interface and add a new project. You can
create as many build steps as you wish and keep each step organized a
little nicer.  

Notiifcations
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
