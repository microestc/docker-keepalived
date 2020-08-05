# docker-keepalived

### use default args
```bash
docker run -it --net host --privileged ccr.ccs.tencentyun.com/microestc/keepalived:latest
```

### custom

```bash
docker run -it --net host --privileged -e CHECK_IP="172.16.1.10" -e CHECK_PORT="2003" ccr.ccs.tencentyun.com/microestc/keepalived:latest
```

```bash
docker run -it --cap-add=NET_ADMIN --name kd -e VIRTUAL_IP=172.16.64.10 -e STATE=BACKUP -e CHECK_PORT=80 --net host ccr.ccs.tencentyun.com/microestc/keepalived:latest
```

### default or more args to see source codes.

