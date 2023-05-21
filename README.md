# Docker ELK stack on Raspberry Pi 4

Run the latest version of the ELK (Elasticseach, Logstash, Kibana) stack with Docker and Docker-compose on Raspberry pi 4.

This project aims to create a search/aggregation stack for IP packets captured using via tshark/wireshark.

Uses Docker images which support Raspberry Pi based on the official images:

* [rpi-elasticsearch](https://www.docker.elastic.co/r/elasticsearch)
* [rpi-logstash](https://www.docker.elastic.co/r/logstash)
* [rpi-kibana](https://www.docker.elastic.co/r/kibana)

# Requirements
1. Raspberry pi 4, 4 GB RAM. 8 GB recommended.
2. tshark.
3. 5 minutes of your time.

## Setup

1. Install [Docker](https://docker.io) on Raspberry Pi.
2. Install [Docker-compose](http://docs.docker.com/compose/install/) on Raspberry Pi.
3. Clone this repository on Raspberry Pi.

*NOTE*: This repository is built upon [deviantony](https://github.com/deviantony/docker-elk) project using arm64 images (v8.6.2) compatible with Raspberry Pi 4.


# Usage

Clone this reposistory:

```bash
$ git clone https://github.com/cgdenis/elk-pi.git
```

Initialize the ELK stack using *docker-compose* in your Raspberry Pi 4:

```bash
$ docker-compose up
```

You can also choose to run it in background (detached mode) by appending the -d flag:

```bash
$ docker-compose up -d
```

Give Kibana about a minute to initialize, then access the Kibana web UI by opening <http://localhost:5601> in a web
browser and use the following (default) credentials to log in:

* user: *elastic*
* password: *changeme*


After verifying Kibana is intialized, navigate to the setup directory and run the index.sh script to create an elasticsearch mapping for tshark packets:

```bash
$ sh index.sh
```
If successful, you should receive the following response:
{
  "acknowledged" : true
}

The script also creates an Kibana data view "packets-*" to access packets data in Elasticsearch. Enter the following (default) credentials when prompted:

* user: *elastic*
* password: *changeme*

Response code 200 indicates a successful call.


# Test Run
To inject logs to the stack, send packet capture content to logstash via tcp:

```bash
$ cat /path/to/logfile.log | nc -q0 localhost 50000
```

Or directly send packet capture from tshark to logstash via tcp:

```bash
$ sudo tshark -c 5 -T ek | nc -q0 localhost 50000
```

Access Kibana UI via [http://raspberry-pi-ip:5601](http://raspberry-pi-ip:5601) with a web browser.

This ELK stack exposes the following ports:
* 50000: Logstash TCP input
* 9200: Elasticsearch HTTP
* 9300: Elasticsearch TCP transport
* 5601: Kibana

# Configuration
For more info on configuration, check out the original [Docker ELK stack repository](https://github.com/deviantony/docker-elk).

**Tested on Raspberry Pi 4**