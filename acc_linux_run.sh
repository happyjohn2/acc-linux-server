#!/bin/bash
# ACC Dedicated Server - Linux 启动与配置脚本

set -e

ACC_EXEC_DIR="$HOME/.wine/drive_c/accds/server"
CFG_DIR="$ACC_EXEC_DIR/cfg"

# ========= 用户交互 =========
echo "📝 输入基本配置:"
read -p "🏁 房间名: " SERVER_NAME
read -p "🛡 管理员密码: " ADMIN_PASSWORD
read -p "🔐 房间密码: " SERVER_PASSWORD
read -p "👥 最大玩家数: " MAX_CLIENTS
read -p "🕓 练习赛时长（分钟）: " PRACTICE_MINUTES
read -p "⏱ 排位赛时长（分钟）: " QUALIFY_MINUTES
read -p "🏁 正赛时长（分钟）: " RACE_MINUTES

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
mkdir -p "$CFG_DIR"
cat <<EOF > "$CFG_DIR/settings.json"
{
  "serverName": "$SERVER_NAME",
  "adminPassword": "$ADMIN_PASSWORD",
  "carGroup": "$CAR_GROUP",
  "trackMedalsRequirement": 3,
  "safetyRatingRequirement": 70,
  "racecraftRatingRequirement": -1,
  "password": "$SERVER_PASSWORD",
  "maxCarSlots": $MAX_CLIENTS,
  "spectatorPassword": "",
  "configVersion": 1
}
EOF

cat <<EOF > "$CFG_DIR/event.json"
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
    { "hourOfDay": 10, "dayOfWeekend": 1, "sessionType": "P", "sessionDurationMinutes": $PRACTICE_MINUTES },
    { "hourOfDay": 13, "dayOfWeekend": 2, "sessionType": "Q", "sessionDurationMinutes": $QUALIFY_MINUTES },
    { "hourOfDay": 15, "dayOfWeekend": 3, "sessionType": "R", "sessionDurationMinutes": $RACE_MINUTES }
  ],
  "configVersion": 1
}
EOF

cat <<EOF > "$CFG_DIR/configuration.json"
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

cat <<EOF > "$CFG_DIR/entrylist.json"
{
  "entries": [],
  "forceEntryList": 0
}
EOF

# 启动服务并输出日志
cd "$ACC_EXEC_DIR"
echo "🎉 ACC Dedicated Server 正在运行..."
echo "📍 赛道: $TRACK | 🚗 车辆: $CAR_GROUP | ☀️ 天气: $WEATHER | 👥 人数: $MAX_CLIENTS"
echo "📄 日志输出位置: ~/acc-server.log"
echo "🛑 可使用 pkill -f accServer.exe 来关闭服务"

wine accServer.exe 2>&1 | tee ~/acc-server.log
