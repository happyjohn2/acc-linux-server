#!/bin/bash
# ACC Dedicated Server - Linux 自动部署脚本（含实时状态与动态重载配置）

set -e

INSTALL_DIR="$HOME/acc-server"
STEAMCMD_DIR="$INSTALL_DIR/steamcmd"
ACC_DIR="$INSTALL_DIR/accds"
ACC_EXEC_DIR="$ACC_DIR/server"

# 修复 --add-architecture 参数
sudo dpkg --add-architecture i386
sudo apt update
sudo apt install -y wine winbind unzip wget dialog inotify-tools libwine:i386 libncurses6:i386 libbz2-1.0:i386 libglu1-mesa:i386

# 下载 SteamCMD
mkdir -p "$STEAMCMD_DIR" && cd "$STEAMCMD_DIR"
wget https://steamcdn-a.akamaihd.net/client/installer/steamcmd.zip -O steamcmd.zip
unzip -o steamcmd.zip

WINEPREFIX="$HOME/.wine"
INSTALL_C_PATH="C:\\accds"

# 自动登录并支持重试 + 可重复输入账号密码
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

# 拷贝服务端
mkdir -p "$ACC_DIR"
cp -r "$WINEPREFIX/drive_c/accds"/* "$ACC_DIR"/

# ========= 用户交互 =========
echo "📝 输入基本配置:"
read -p "🏁 房间名: " SERVER_NAME
read -p "🛡 管理员密码: " ADMIN_PASSWORD
read -p "🔐 房间密码: " SERVER_PASSWORD
read -p "👥 最大玩家数: " MAX_CLIENTS

TRACK=$(dialog --stdout --title "选择赛道" --menu "选择一个赛道" 20 60 14 \
  spa "Spa-Francorchamps" \
  monza "Monza" \
  nurburgring "Nürburgring" \
  paul_ricard "Paul Ricard" \
  zandvoort "Zandvoort" \
  misano "Misano" \
  brands_hatch "Brands Hatch" \
  silverstone "Silverstone" \
  barcelona "Barcelona" \
  imola "Imola" \
  mount_panorama "Mount Panorama" \
  laguna "Laguna Seca" \
  donington "Donington Park" \
  watkins_glen "Watkins Glen")

CAR_GROUP=$(dialog --stdout --title "选择车型" --menu "允许车辆组" 10 40 5 \
  FreeForAll "允许所有" \
  GT3 "仅 GT3" \
  GT4 "仅 GT4" \
  TCX "BMW Cup" \
  GT2 "GT2" \
  GTC "Cup 系列")

WEATHER=$(dialog --stdout --title "选择天气" --menu "天气设置" 10 40 5 \
  clear "晴天" \
  cloudy "多云" \
  random "随机" \
  rain "雨天")

case $WEATHER in
  clear) CLOUD=0.0; RAIN=0.0; RANDOMNESS=0;;
  cloudy) CLOUD=0.4; RAIN=0.0; RANDOMNESS=1;;
  random) CLOUD=0.3; RAIN=0.1; RANDOMNESS=4;;
  rain) CLOUD=0.8; RAIN=0.7; RANDOMNESS=2;;
esac

# 生成配置
mkdir -p "$ACC_EXEC_DIR/cfg"
cat <<EOF > "$ACC_EXEC_DIR/cfg/settings.json"
{
  "serverName": "$SERVER_NAME",
  "adminPassword": "$ADMIN_PASSWORD",
  "carGroup": "$CAR_GROUP",
  "trackMedalsRequirement": 0,
  "safetyRatingRequirement": 0,
  "racecraftRatingRequirement": 0,
  "password": "$SERVER_PASSWORD",
  "maxCarSlots": $MAX_CLIENTS,
  "spectatorPassword": "",
  "configVersion": 1
}
EOF

cat <<EOF > "$ACC_EXEC_DIR/cfg/event.json"
{
  "track": "$TRACK",
  "preRaceWaitingTimeSeconds": 30,
  "sessionOverTimeSeconds": 120,
  "ambientTemp": 22,
  "trackTemp": 27,
  "cloudLevel": $CLOUD,
  "rain": $RAIN,
  "weatherRandomness": $RANDOMNESS,
  "sessions": [
    { "hourOfDay": 13, "dayOfWeekend": 2, "sessionType": "Q", "sessionDurationMinutes": 10 },
    { "hourOfDay": 15, "dayOfWeekend": 3, "sessionType": "R", "sessionDurationMinutes": 15 }
  ],
  "configVersion": 1
}
EOF

cat <<EOF > "$ACC_EXEC_DIR/cfg/configuration.json"
{
  "formationLapType": 3,
  "isRefuellingAllowedInRace": true,
  "isRefuellingTimeFixed": false,
  "isMandatoryPitstopRequired": false,
  "maxDriversCount": 1,
  "isDriverSwapAllowed": false,
  "hasAutoDQ": 1,
  "stintLengthSec": 0,
  "maxTotalDrivingTime": 0,
  "ambientTemp": 22,
  "trackTemp": 27,
  "configVersion": 1
}
EOF

cat <<EOF > "$ACC_EXEC_DIR/cfg/entrylist.json"
{
  "entries": [],
  "forceEntryList": 0
}
EOF

# 启动并监控热重载
cd "$ACC_EXEC_DIR"
echo "🎉 ACC Dedicated Server 已部署:"
echo "📍 赛道: $TRACK | 🚗 车辆: $CAR_GROUP | ☀️ 天气: $WEATHER | 👥 人数: $MAX_CLIENTS"
echo "🔄 正在监控 cfg/*.json 配置文件，保存即重启..."

while true; do
  wine accServer.exe &
  SERVER_PID=$!
  inotifywait -e modify "$ACC_EXEC_DIR/cfg"/*.json
  echo "🔁 配置更改已检测，重启服务器..."
  kill $SERVER_PID
  wait $SERVER_PID 2>/dev/null
  sleep 1
done
