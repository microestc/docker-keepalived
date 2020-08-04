#!/bin/bash

cat << EOF > /etc/keepalived/keepalived.conf
global_defs {
   script_user root
   enable_script_security
}

vrrp_script chk_health {
  script '${CHECK_SCRIPT_PATH:-/etc/keepalived/health.sh}'
  interval ${CHECK_INTERVAL:-5} 
  fall ${CHECK_FALL:-3}
  rise ${CHECK_RISE:-1}
  user root
  timeout 20
}

vrrp_instance VI_1 {
    interface ${INTERFACE:-eth0}
    state ${STATE:-MASTER}
    virtual_router_id ${VIRTUAL_ROUTER_ID:-51}
    priority ${PRIORITY:-100}
    advert_int ${ADVERT_INT:-1}

    virtual_ipaddress {
        ${VIRTUAL_IP:-172.16.0.10}
    }

    track_interface {
        ${INTERFACE:-eth0}
    }

    authentication {
        auth_type PASS
        auth_pass ${PASSWORD:-admin}
    }

    track_script {
        chk_health
    }
}
EOF

cat << EOF > /etc/keepalived/health.sh
#!/bin/bash

if nc -z ${CHECK_IP:-127.0.0.1} ${CHECK_PORT:-2003}
then
    echo "$(date) -------> tcp port:${CHECK_PORT:-2003} normal." >> /keepalived.log
else
    echo "$(date) ------> switching master node." >> /keepalived.log
    # /etc/init.d/keepalived stop
        start-stop-daemon --stop --quiet --pidfile /var/run/keepalived.pid --exec /usr/sbin/keepalived || true
        exit 1
fi
exit 0
EOF

chmod +x /etc/keepalived/health.sh

/usr/sbin/keepalived -n -l -D -f /etc/keepalived/keepalived.conf