# ACC Linux Dedicated Server 一键部署脚本

本脚本用于在 Linux 环境下（Ubuntu/Debian）快速部署 Assetto Corsa Competizione（ACC）专用服务器，使用 Wine 模拟 Windows 环境，支持 SteamCMD 自动下载、赛道/车型/天气交互选择以及配置文件实时热重载。

---

## 🚀 使用方法（Linux服务器）

```bash
git clone https://github.com/happyjohn2/acc-linux-server.git
cd acc-linux-server
chmod +x acc_linux_autodeploy.sh
./acc_linux_autodeploy.sh
```

---

## ✅ 功能特性

- 自动安装 Wine 与依赖
- 自动下载 SteamCMD 并登录
- 登录失败支持账号密码重试（Steam Guard 兼容）
- 图形化选择赛道、天气、车型
- 自动生成配置文件（event、settings、entrylist 等）
- 修改配置文件后自动重启服务器
- 服务端安装路径：`~/acc-server/accds/server`

---

## 🛠 系统要求

- Ubuntu 20.04+ / Debian 10+
- 推荐 2 核 4G 内存以上
- 建议 x86_64 架构主机
- 无需图形界面

---

## 📝 配置说明

所有配置文件位于：

```
~/acc-server/accds/server/cfg/
```

修改后自动触发热重启。

---

## 🔄 常用命令（运行后）

```bash
cd ~/acc-server/accds/server
./accServer.exe      # 使用 Wine 运行
```

---

## 📦 项目结构

```
acc-linux-server/
├── acc_linux_autodeploy.sh     # 自动部署脚本
├── README.md                   # 使用说明
~/acc-server/
└── accds/
    └── server/
        ├── accServer.exe
        └── cfg/
            ├── settings.json
            ├── event.json
            └── ...
```
```
