# ACC Dedicated Server 部署脚本 (Linux + Wine)

本脚本用于在 Linux 系统上通过 Wine 快速部署并运行 Assetto Corsa Competizione (ACC) 的多人专用服务器。

---

## 🧰 功能特性

- 一次性输入房间配置（名称、密码、玩家数、车型、天气等）
- 自动生成所需配置文件（settings.json / event.json 等）
- 支持选择练习赛、排位赛、正赛时长
- 启动服务并保持后台运行

---

## 🚀 使用步骤

```bash
# 克隆代码（如尚未存在）
git clone https://github.com/happyjohn2/acc-linux-server.git
cd acc-linux-server

# 赋予执行权限
chmod +x acc_linux_run.sh

# 运行脚本
./acc_linux_run.sh
```

---

## 🔧 管理服务

### ✅ 查看服务器状态（实时日志）
```bash
tail -f ~/acc-server.log
```

### 🛑 关闭服务
```bash
pkill -f accServer.exe
```

---

## 📄 配置文件路径
所有配置将写入：
```
~/.wine/drive_c/accds/server/cfg/
```

---

## 🗒 注意事项

- 建议服务器内存为 **4G 或以上**，CPU 至少 2 核
- 本脚本依赖 Wine 环境运行 ACC 原生 Windows 服务端
- 首次运行建议使用 Ubuntu 20.04/22.04，Debian 也可兼容

---

## 📬 联系维护者
如有建议或问题，欢迎提 Issue 或联系 @happyjohn2
