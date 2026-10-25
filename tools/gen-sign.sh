#!/bin/bash
# 生成本地自签名证书（release 构建用）。sign/ 已在 .gitignore 中，私钥不要提交。
set -e; cd "$(dirname "$0")/.."; mkdir -p sign
[ -f sign/private.pem ] && { echo "sign/private.pem 已存在"; exit 0; }
openssl req -newkey rsa:2048 -nodes -keyout sign/private.pem -x509 -days 3650 -out sign/certificate.pem -subj "/CN=vela-quicknote-wm3/O=local"
chmod 600 sign/private.pem
