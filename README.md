![atlas logo](https://i.gyazo.com/eaf4dfa7e6f26cf89348eff67cd37af4.png)

[Atlas](https://atlas.apache.org/) is a scalable and extensible set of core foundational governance services – enabling enterprises to effectively and efficiently meet their compliance requirements within Hadoop and allows integration with the whole enterprise data ecosystem.

Apache Atlas provides open metadata management and governance capabilities for organizations to build a catalog of their data assets, classify and govern these assets and provide collaboration capabilities around these data assets for data scientists, analysts and the data governance team.

# Disclaimer
This is a development deployment  and should not be used for production. For production, you'd want to deploy your database and indexing service (i.e. HBase and Solr) separately and then configure Atlas to utilize them.

# Building Atlas

If you want to build the Atlas image then you must first build the sources. Doing so is simple enough, just run `sudo make build`. After that operation completes, you can initiate a simple docker build as follows, `docker build . -t sansarip/apache-atlas`.

# Running Atlas

The nice thing about this image is that you can run a container using the `atlas` (uid `47145`) user instead of root. In other words, this image can run without requiring root privileges, so it's much safer. After running, the UI should be available on port 21000 in about 5-10 minutes.

## Run
```docker run -p 21000:21000 -it --rm -u atlas sansarip/apache-atlas```

Add the `-d` flag to run the container in background:

```docker run -p 21000:21000 -d --rm -u atlas sansarip/apache-atlas```

## Run with Volume Mount
The following command will mount the entire atlas install folder; this entails persistent storage as well. Replace the angular brackets and the content held within them with the appropriate information:

```docker run -p 21000:21000 -v <your-volume>:/opt/apache-atlas-<atlas-version> -it -u atlas sansarip/apache-atlas```

## Configuration
Here's an example of configuring Atlas at run-time:

```docker run -p 21000:21000 -it -u atlas sansarip/apache-atlas /bin/bash -c "/opt/atlas_configure.sh atlas.server.bind.address=apache-atlas; /opt/atlas_start.sh"```

The `atlas.server.bind.address=apache-atlas` argument above is an example of an Atlas configuration. You can pass as many of these as you'd like, just make sure your last configuration ends with a semicolon as shown in the command above.

*OR*

Alternatively, you can configure Atlas by following the volume mount instructions above and editing `conf/atlas-application.properties` directly. 

See the [Atlas configuration docs](https://atlas.apache.org/Configuration.html) for instructions on configuring Atlas.

# Stopping Atlas

To stop atlas gracefully, run the following command:

`docker stop -t 30 <your-container-name>`

The above command will allow Atlas 30 seconds to shut down properly, and then it will forceably kill the container. You can adjust the grace period by increasing (or decreasing) the argument to the `-t` flag.

## Alternative

An alternative way to stop Atlas is as follows:

`docker exec -it <your-container-name> python2.7 /opt/apache-atlas-1.1.0/bin/atlas_stop.py`

Then you can safely remove/kill the docker container. Or, you can start Atlas up again on the same container with `docker exec -it <your-container-name> python2.7 /opt/apache-atlas-1.1.0/bin/atlas_start.py`

# To Do

✔️ reduce image size

✔️ upgrade to version 2.0

✔️ make persistent

✔️ gracefully stop Atlas on `docker stop` call

✔️ run as non-root user

✔️ build status
