Puppet module for ZooKeeper
===========================

I use this module to set up and manage basic ZooKeeper ensembles for
my personal projects.  You probably don't want to 'git submodule' this
directly into your Puppet repo because I can't guarantee backwards
compatibility, but feel free to copy if you find any of it useful.

Tested with Puppet 4.2.0


Assumptions
-----------

This module assumes:

* your machines are able to install new Debian/Ubuntu packages
    * e.g. they have Internet access or have an apt proxy configured
* you're using Hiera
* you're using Hiera to assign classes to machines
    * i.e. have `hiera_include('classes')` set in `site.pp`

It wouldn't be much work to adapt this module if your environment
doesn't match those assumptions, but I don't have such a use case.


The way I use it
----------------

Assuming I wanted to create an ensemble named `yolo` made up of three
machines (`zk0`, `zk1`, and `zk2`), I'd add the following to
`hiera/global.yaml`:

```
zk: 
    yolo:
        - host: zk0
          server_id: 1
        - host: zk1
          server_id: 2
        - host: zk2
          server_id: 3
```

You can add more than one ensemble.

For each zk server I'd add the following to
`hiera/hosts/<hostname>.yaml`:

```
classes:
    - zk::server
```

Then run Puppet and `/sbin/restart zookeeper` (restarts aren't
initiated by Puppet here so they can be orchestrated elsewhere).
