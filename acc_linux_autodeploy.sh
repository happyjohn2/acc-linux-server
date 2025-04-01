#!/bin/bash
# ACC Dedicated Server - Linux 部署脚本（仅安装阶段）

set -e

INSTALL_DIR="$HOME/acc-server"
STEAMCMD_DIR="$INSTALL_DIR/steamcmd"
WINEPREFIX="$HOME/.wine"
INSTALL_C_PATH="C:\\accds"

# 安装依赖
sudo dpkg --add-architecture i386
sudo apt update
sudo apt install -y wine winbind unzip wget dialog inotify-tools libwine:i386 libncurses6:i386 libbz2-1.0:i386 libglu1-mesa:i386

# 下载 SteamCMD
mkdir -p "$STEAMCMD_DIR" && cd "$STEAMCMD_DIR"
wget https://steamcdn-a.akamaihd.net/client/installer/steamcmd.zip -O steamcmd.zip
unzip -o steamcmd.zip

# 登录并安装 ACC Dedicated Server
retry_count=0
while true; do
  read -p "🔑 请输入你的 Steam 账号: " steam_user
  read -s -p "🔐 请输入你的 Steam 密码: " steam_pass
  echo

  cat <<EOF > $STEAMCMD_DIR/install_acc.txt
force_install_dir $INSTALL_C_PATH
login $steam_user $steam_pass
app_update 1430110 validate
quit
EOF

  wine "$STEAMCMD_DIR/steamcmd.exe" -overrideminos +runscript install_acc.txt

  ACC_PATH="$WINEPREFIX/drive_c/accds/server/accServer.exe"
  echo "📂 正在检查服务端路径: $ACC_PATH"

  if [[ -f "$ACC_PATH" ]]; then
    echo "✅ ACC Dedicated Server 安装成功！"
    break
  else
    echo "❌ 未检测到 accServer.exe，下载可能失败或路径错误"
  fi

  retry_count=$((retry_count+1))
  echo "❌ 登录或下载失败，是否重新输入账号密码？（y/n）"
  read -r answer
  if [[ "$answer" != "y" && "$answer" != "Y" ]]; then
    echo "❗ 用户终止登录，退出脚本。"
    exit 1
  fi

  if [ $retry_count -ge 10 ]; then
    echo "❗ 连续10次失败，退出脚本。"
    exit 1
  fi
  sleep 3
  clear
done
