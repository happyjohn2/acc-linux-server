# ACC Dedicated Server 一键部署与启动脚本 (Linux + Wine)

本项目提供两个脚本：

- `acc_linux_autodeploy.sh`：用于首次部署环境并下载 ACC 服务端（Wine + SteamCMD）
- `acc_linux_run.sh`：用于运行服务器，包含赛道/天气/时长等可选项，生成配置并后台运行

---

## 🧰 功能特性

- Wine 环境自动部署，包含 steamcmd 安装及登录（交互式）
- 自动下载并安装 ACC Dedicated Server
- 一次性输入房间配置（名称、密码、玩家数、车型、天气等）
- 支持选择练习赛、排位赛、正赛时长
- 自动生成所需配置文件（settings.json / event.json 等）
- 启动服务并保持后台运行（实时日志写入 `~/acc-server.log`）

---

## 🧱 第一步：部署依赖 + 安装服务端

运行部署脚本：

```bash
chmod +x acc_linux_autodeploy.sh
./acc_linux_autodeploy.sh
```

你会被提示输入 Steam 账号与密码，系统会自动下载服务端并安装到：

```
~/.wine/drive_c/accds/server/
```

---

## 🚀 第二步：运行服务器（配置 + 启动）

```bash
chmod +x acc_linux_run.sh
./acc_linux_run.sh
```

运行脚本后将会：

- 询问你房间名、管理员密码、最大玩家数等信息
- 选择赛道、天气、车辆组
- 设置练习赛、排位赛、正赛的时长（分钟）
- 自动生成完整配置文件并启动服务器

服务启动后将实时输出日志，并保存到：

```
~/acc-server.log
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

- 建议服务器配置：**2 核 + 4GB 内存或以上**
- 请确保 Linux 环境可以访问 Steam 服务器（建议国内服务器使用 IPv4）
- 该服务为 Wine 启动的 Windows 服务端，稳定性已验证，但官方建议使用原生 Windows

---

## 📬 最后说明
本项目由 GPT 协助生成，若有问题可提交 Issue，但联系作者未必有用。
