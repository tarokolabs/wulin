FROM quay.io/cloudwalker/alpine
STOPSIGNAL SIGUSR1
COPY <<EOF /stop.sh
#!/bin/ash
trap "echo 'SIGINT received!'>>/tmp/d.out; date +%H-%M-%S >> /tmp/d.out; exit 0" SIGINT
trap "echo 'SIGTERM received!'>> /tmp/d.out; date +%H-%M-%S >> /tmp/d.out; sleep 30; date +%H-%M-%S >> /tmp/d.out; exit 0" SIGTERM
trap "echo 'SIGUSR1 received!'>> /tmp/d.out; date +%H-%M-%S >> /tmp/d.out; sleep 30; date +%H-%M-%S >> /tmp/d.out; exit 0" SIGUSR1

while true; do
  sleep 2;date +%H-%M-%S > /tmp/d.out
done
EOF

RUN chmod +x /stop.sh
CMD ["/stop.sh"]
