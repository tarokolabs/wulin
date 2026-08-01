#!/bin/bash
# webhook-handler.sh

# 1. 讀取 HTTP Request Line
read -r request_line

# 2. 讀取 Headers 並精準解析 Content-Length
content_length=0
while read -r header; do
    # 移除 \r 換行符號
    header=$(echo "$header" | tr -d '\r')
    [ -z "$header" ] && break
    
    # 忽略大小寫比對 Content-Length
    if echo "$header" | grep -qi "^Content-Length:"; then
        content_length=$(echo "$header" | awk '{print $2}')
    fi
done

# 3. 安全地讀取 Body (使用 dd 取代 read)
if [ "$content_length" -gt 0 ]; then
    # 使用 dd 精確讀取指定的 byte 數量，這能完美抵抗 TCP 封包分段延遲的問題
    payload=$(dd bs=1 count="$content_length" 2>/dev/null)
    
    echo "========== [$(date '+%Y-%m-%d %H:%M:%S')] 新告警事件 ==========" >&2
    if [ -n "$payload" ]; then
        # 解析並輸出格式化 JSON
        echo "$payload" | jq . >&2
    else
        echo "警告: 讀取到的 Payload 為空" >&2
    fi
    echo "================================================================" >&2
fi

# 4. 標準且完整的 HTTP 200 回應
# 加上 Connection: close 明確告知 Client 傳輸結束
echo -en "HTTP/1.1 200 OK\r\n"
echo -en "Content-Type: text/plain\r\n"
echo -en "Connection: close\r\n"
echo -en "Content-Length: 2\r\n\r\n"
echo -en "OK"

# 5. 關鍵防護：稍微暫停 0.1 秒
# 確保 socat 有足夠的時間將 buffer 內的 TCP 封包(200 OK)完整推送到 Alertmanager 端，才關閉 Socket
sleep 0.2
