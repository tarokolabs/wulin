FROM alpine:3.19

# 安裝 bash, jq (解析 JSON) 以及 socat (處理網路 Socket)
RUN apk add --no-cache bash jq socat tzdata

# 設定時區為台北
ENV TZ=Asia/Taipei

COPY webhook-handler.sh /usr/local/bin/webhook-handler.sh
RUN chmod +x /usr/local/bin/webhook-handler.sh

# 使用 socat 監聽 8080 Port，每當有連線就 Fork 一個 Bash 處理
CMD ["socat", "TCP4-LISTEN:8080,fork,reuseaddr", "EXEC:/usr/local/bin/webhook-handler.sh"]
