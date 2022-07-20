# Firehol ipsets-update Docker Image

A docker image to pull ip lists ("ipsets") from [Firehol](http://iplists.firehol.org/)

The intended usecase of this image is:  pulling all of the latest IPs collected by [Firehol](http://iplists.firehol.org/) to their local disk so they can be used for something else (ingested into another tool, used for analysis, etc).

This image *does not* do any firewall configuration or any analysis-- it just downloads IPs to your host.  

The image currently pulls all lists.

## References

  * [Firehol IP List](http://iplists.firehol.org/)
  * [Downloading IP Lists](https://github.com/firehol/blocklist-ipsets/wiki/Downloading-IP-Lists)

## Roadmap

   * Command line for sleep interval
   * Allow fine control of which lists are pulled
   * Rsync with cloud bucket

##  Quick Start

1. Pull the docker image.  

    ```
    docker pull henderso/firehol-ipsets-update-docker
    ```

2.  Make and local directory

    ```
    mkdir /tmp/firehol
    ```

3.  Run the container, mapping the folder from 2 (e.g. `/tmp/firehol`) to the container's working firehol dir (`/home/analyst/ipsets`).  The mapped host folder needs to be *relative*

    ```
    docker run -v /tmp/firehol:/home/analyst/ipsets  henderso/firehol-ipsets-update-docker
    ```

This will run the latest built container, and mount the container's ipset directory to `/tmp/firehol`.  The container will continue to run on an infiite loop, updating this lists periodically.

The docker output should show alot of streaming text as the ipsets are uploaded:

```
.
.
.

             normshield_all_height:| source file has been updated
                                   | converting with '/usr/bin/cat'
                                   |  SAME  processed set is the same with the previous one.
                                   | 
            normshield_high_height:| source file has been updated
                                   | converting with '/usr/bin/cat'
                                   |  SAME  processed set is the same with the previous one.
.
.
.
```

You can then see all the lists in your local folder:

    ```
    ls /tmp/firehol
    alienvault_reputation.ipset     dshield.source                  php_dictionary_1d.ipset             sslbl_aggressive.ipset
    alienvault_reputation.source    dshield_top_1000.source         php_dictionary_1d.source            sslbl_aggressive.source
    asprox_c2.source                dyndns_ponmocup.ipset           php_dictionary_30d.ipset            sslbl.ipset
    blocklist_de_apache.ipset       dyndns_ponmocup.source          php_dictionary_30d.source           sslbl.source
    blocklist_de_apache.source      errors                          php_dictionary_7d.ipset             sslproxies_1d.ipset
    blocklist_de_bots.ipset         et_block.netset                 php_dictionary_7d.source            sslproxies_1d.source
    blocklist_de_bots.source        et_block.source                 php_dictionary.ipset                sslproxies_30d.ipset
    blocklist_de_bruteforce.ipset   et_botcc.source                 php_dictionary.source               sslproxies_30d.source
    blocklist_de_bruteforce.source  et_compromised.ipset            php_harvesters_1d.ipset             sslproxies_7d.ipset
    blocklist_de_ftp.ipset          et_compromised.source           php_harvesters_1d.source            sslproxies_7d.source
    blocklist_de_ftp.source         et_dshield.netset               php_harvesters_30d.ipset            sslproxies.ipset
    .
    .
    .
    ```

Note:  **When you first run the container the directory will be empty**.  It should fill in about 10-15 min and refresh every hour.

Internet access is required, as `update-ipsets` will want to reach out and pull the lists

The build will take 5-20 minutes depending on your internet connection.

You may see messages like:   `...I am not allowed to talk to the kernel.` or connection errors around some IPs.
Most of the messages can be ignore, as a typical ipset run always has a few errors.

If you are getting new files in your mapped host dir you can assume things are working.  After a run, you should see a message:


```
Sleeping until next refresh...
```
   
Once you confirm things are working, break out of the `docker run` and then restart in daemon mode:


```
docker run -d -v /tmp/firehol:/home/analyst/firehol/ipsets henderso/firehol-ipsets-update-docker
```

Leave this running and your host folder will always have up-to-date firehol data.


##  Building

You can rebuild the container to meet your needs as follows:

Execute the following.  The `build-arg` will ensure the docker container user, `analyst` has the same UID/GID as your host user so you can mount the host directory without drama.

```
docker build --build-arg GROUPID=$(id -g) --build-arg USERID=$(id -u) -t firehol-ipsets-update-docker .
```

### Running 

```
docker run -v /tmp/firehol:/home/analyst/ipsets firehol-ipsets-update-docker
```