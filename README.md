# netdata Docker

A simple, fully configurable from env docker container for [netdat](https://github.com/firehol/netdata). 

The goal was to configure `every` part of the config. also the base image is `alpine` and the result image is very small. 

*TODO* : Proper documents

## How config work?

For config netdata via env use this syntax : 

``` 
-e ND_{ANYTHING}="file.conf|section/key=value"
```
for example to edit `update every` in `netdata.conf` and `global` section: 

``` 
-e ND_1="netdata.conf|global/update every = 5"
```