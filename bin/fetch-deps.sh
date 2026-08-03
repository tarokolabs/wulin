#!/usr/bin/env bash
# fetch-deps——取得教材建置與 lab 所需的第三方二進位（#16）
#
# 這些檔案不隨 repo 散佈（授權合規與供應鏈信任），由本腳本自權威來源
# 下載並以 SHA256 釘死；校驗失敗即刪除半成品並以非零退出。
#
# 用法：
#   bin/fetch-deps.sh              # 全部
#   bin/fetch-deps.sh mariadb      # 只取檔名含關鍵字的項目
#
# ⚠ OpenSSL 1.1.1f（三個 deb）已於 2023-09 EOL、不含後續安全修補——
#   依團隊決議（tk8s#14）僅限教學叢集內部使用，不得用於任何對外服務。
#   依賴它的是舊版 Hadoop/Hive lab image（usdt.hdp34/usdt.hdp35/uslkh）。

set -u
WULIN="$(cd "$(dirname "$(realpath "$0")")/.." && pwd)"
CACHE="${WULIN}/.fetch-cache"
mkdir -p "${CACHE}"
FILTER="${1:-}"

MAVEN=https://repo1.maven.org/maven2
UBU=http://archive.ubuntu.com/ubuntu/pool/main/o/openssl
APACHE=https://archive.apache.org/dist

fail=0
done_n=0

fetch() {  # <sha256> <url> <目的目錄（相對 repo 根）...>
   local sha="$1" url="$2"; shift 2
   local name="${url##*/}" c d
   [ -n "${FILTER}" ] && [[ "${name}" != *"${FILTER}"* ]] && return 0
   c="${CACHE}/${name}"
   if [ ! -f "${c}" ] || ! echo "${sha}  ${c}" | sha256sum -c - &>/dev/null; then
      echo "下載 ${name}"
      curl -sfL "${url}" -o "${c}.part" || { echo "  ✗ 下載失敗：${url}"; rm -f "${c}.part"; fail=1; return 1; }
      echo "${sha}  ${c}.part" | sha256sum -c - &>/dev/null \
         || { echo "  ✗ SHA256 不符：${name}"; rm -f "${c}.part"; fail=1; return 1; }
      mv "${c}.part" "${c}"
   fi
   for d in "$@"; do
      mkdir -p "${WULIN}/${d}"
      cp "${c}" "${WULIN}/${d}/${name}"
   done
   echo "  ✓ ${name} → $*"
   done_n=$((done_n+1))
}

# spark-examples 未發佈於 Maven Central——自官方發行版抽取（dist 以官方 .sha512 校驗）
fetch_spark_examples() {  # <spark版本> <jar的sha256> <目的目錄>
   local v="$1" sha="$2" dest="$3"
   local jar="spark-examples_2.12-${v}.jar" c tgz want got
   [ -n "${FILTER}" ] && [[ "${jar}" != *"${FILTER}"* ]] && return 0
   c="${CACHE}/${jar}"
   if [ ! -f "${c}" ] || ! echo "${sha}  ${c}" | sha256sum -c - &>/dev/null; then
      echo "下載 spark-${v} 官方發行版（數百 MB，僅為抽取 ${jar}）"
      tgz="${CACHE}/spark-${v}-bin-hadoop3.tgz"
      curl -sfL "${APACHE}/spark/spark-${v}/spark-${v}-bin-hadoop3.tgz" -o "${tgz}.part" \
         || { echo "  ✗ 下載失敗"; rm -f "${tgz}.part"; fail=1; return 1; }
      want=$(curl -sfL "${APACHE}/spark/spark-${v}/spark-${v}-bin-hadoop3.tgz.sha512" | grep -oiE '[0-9a-f]{128}' | tr -d '\n' | tr 'A-F' 'a-f')
      got=$(sha512sum "${tgz}.part" | cut -d' ' -f1)
      [ "${want}" == "${got}" ] || { echo "  ✗ 發行版 SHA512 不符"; rm -f "${tgz}.part"; fail=1; return 1; }
      mv "${tgz}.part" "${tgz}"
      tar xzf "${tgz}" -C "${CACHE}" "spark-${v}-bin-hadoop3/examples/jars/${jar}"
      mv "${CACHE}/spark-${v}-bin-hadoop3/examples/jars/${jar}" "${c}"
      rm -rf "${CACHE}/spark-${v}-bin-hadoop3" "${tgz}"
      echo "${sha}  ${c}" | sha256sum -c - &>/dev/null \
         || { echo "  ✗ jar SHA256 不符"; rm -f "${c}"; fail=1; return 1; }
   fi
   mkdir -p "${WULIN}/${dest}"
   cp "${c}" "${WULIN}/${dest}/${jar}"
   echo "  ✓ ${jar} → ${dest}"
   done_n=$((done_n+1))
}

# ── Maven Central（同目錄 .sha1 於清單生成時已核）─────────────────────────
fetch 26fc67b3022a6e85323b76ebb4c26994ec1a6b11ec7344483244c4e50ff79ce0 \
  ${MAVEN}/org/mariadb/jdbc/mariadb-java-client/2.3.0/mariadb-java-client-2.3.0.jar \
  labs/dt/conf/hive-3.1.3 labs/dt/conf/hive-4.0.1 labs/dt/conf/hive-4.1.0 labs/dt/conf/hive-4.2.0

fetch ccf16f38a7bc5bd55e59aa5e3590d74faebb2fb92d111ed5641d5175c4a3624a \
  ${MAVEN}/org/mariadb/jdbc/mariadb-java-client/2.7.12/mariadb-java-client-2.7.12.jar \
  images/jupyter images/usdt.hdp34 images/usdt.hdp35 images/usdt.hdpclient images/uslkh \
  labs/dt/conf/hive-4.0.1 labs/dt/conf/hive-4.1.0 labs/dt/conf/hive-4.2.0 labs/lkh/conf/hive-4.0.1

fetch 85c4ba2f221d0dfd439c26affbb294f784960763544263c65aba9c2c76858706 \
  ${MAVEN}/org/mariadb/jdbc/mariadb-java-client/3.5.3/mariadb-java-client-3.5.3.jar \
  labs/dt/conf/hive-4.0.1 labs/dt/conf/hive-4.1.0 labs/dt/conf/hive-4.2.0 labs/lkh/conf/hive-4.0.1

fetch d503497f2d41959c8432f0171eafb51ce36d149afac444ee2f16286f6cda0dbc \
  ${MAVEN}/com/amazonaws/aws-java-sdk-bundle/1.12.694/aws-java-sdk-bundle-1.12.694.jar \
  images/spark

fetch 53f9ae03c681a30a50aa17524bd9790ab596b28481858e54efd989a826ed3a4a \
  ${MAVEN}/org/apache/hadoop/hadoop-aws/3.3.4/hadoop-aws-3.3.4.jar \
  images/spark

# ── Apache archive（.sha512 於清單生成時已核）──────────────────────────────
fetch b020c122a206ad390ba3f55aa4253faa5e7a3c844a42e724e2ec9bde35876b6c \
  ${APACHE}/tez/0.10.5/apache-tez-0.10.5-bin.tar.gz \
  labs/dt/bin

fetch_spark_examples 3.4.2 6676a6044a5ad650e8e48fd8a9e5df0a905c676233cbff1951299730372ceda7 images/spark
fetch_spark_examples 3.5.1 dc5b56483fcb51325455a978d67e48ad9e09e1caf511c8deec01282910360c6e images/spark

# ── Ubuntu archive（focal GA 版本；⚠ EOL，適用範圍見檔頭）────────────────
fetch 0b47fac737cfe18bcdd20773bc4a52485e21d18d144126c535d2c58ff58889bb \
  ${UBU}/openssl_1.1.1f-1ubuntu2_amd64.deb \
  images/usdt.hdp34 images/usdt.hdp35 images/uslkh

fetch 09ee28588a1fb5613ddc6c26a992d5a76931b3cf22c022930da413a5e580599e \
  ${UBU}/libssl1.1_1.1.1f-1ubuntu2_amd64.deb \
  images/usdt.hdp34 images/usdt.hdp35 images/uslkh

fetch d053feaaf2a2b55a23bb8e068b868ea0aa5c6a5ae41267228b25fc18a234cdba \
  ${UBU}/libssl-dev_1.1.1f-1ubuntu2_amd64.deb \
  images/usdt.hdp34 images/usdt.hdp35 images/uslkh

echo
if [ "${fail}" != "0" ]; then
   echo "有項目失敗（見上方 ✗）——半成品已清除，重跑即可續傳（快取於 .fetch-cache/）"
   exit 1
fi
echo "完成：${done_n} 項就緒"
