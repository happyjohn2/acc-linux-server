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
- 自动生成 `settings.json`、`event.json` 等配置文件
- 修改配置文件后自动重启服务

---

## 💡 注意事项

- 需要联网环境
- 脚本运行时会提示你输入 Steam 账号、密码
- 若遇到 Steam 登录失败或验证码等待超时，可选择重输或重试

---

## 📦 输出目录结构

```bash
~/acc-server/
├── steamcmd/        # SteamCMD 执行环境
├── accds/           # ACC Dedicated Server 安装目录
│   ├── cfg/         # 所有配置文件
│   ├── accServer.exe
│   └── ...
```

---

## 🛠 支持系统

- Ubuntu 20.04+
- Debian 10+
- 建议使用 x86 架构主机（建议 2C4G 起步）
