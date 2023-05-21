
#!/bin/bash

#create elasticsearch mappings for tshark
curl -X PUT "localhost:9200/_index_template/packets?pretty" -H 'Content-Type: application/json' -d'
{
   "index_patterns": "packets-*",
    "template": {
    "settings": {
      "number_of_shards": 1
    },
    "mappings": {
        "dynamic": "false",
        "properties": {
          "timestamp": {
            "type": "date"
          },
          "layers": {
            "properties": {
              "frame": {
                "properties": {
                  "frame_frame_len": {
                    "type": "long"
                  },
                  "frame_frame_protocols": {
                    "type": "keyword"
                  }
                }
              },
              "ip": {
                "properties": {
                  "ip_ip_src": {
                    "type": "ip"
                  },
                  "ip_ip_dst": {
                    "type": "ip"
                  }
                }
              },
              "udp": {
                "properties": {
                  "udp_udp_srcport": {
                    "type": "integer"
                  },
                  "udp_udp_dstport": {
                    "type": "integer"
                  }
                }
              },
              "tcp": {
                "properties": {
                  "tcp_tcp_srcport": {
                    "type": "integer"
                  },
                  "tcp_tcp_dstport": {
                    "type": "integer"
                  }
                }
              }
            }
          }
        }

    }
  }
}
'

echo "Now provide Kibana credentials to create data view:"
#create elasticsearch data view
read -p "Enter username: " username

# Prompt for password
read -s -p "Enter password: " password
echo

data="username=$username&password=$password"

curl -u $username:$password -X POST "localhost:5601/api/data_views/data_view" -H 'kbn-xsrf: true' -H 'Content-Type: application/json' -d'
{
  "data_view": {
     "title": "packets-*",
     "name": "Packets Capture"
  }
}
'
