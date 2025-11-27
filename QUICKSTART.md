# 🚀 GitHub快速部署指南

> **只需3步,5分钟完成部署!**

---

## 📋 部署前检查

确保您已完成:
- ✅ 安装了Git (下载: https://git-scm.com/download/win)
- ✅ 拥有GitHub账号 (注册: https://github.com/signup)

---

## 🎯 快速部署 (3步完成)

### 步骤1: 在GitHub上创建仓库

1. 登录GitHub: https://github.com
2. 点击右上角 `+` → `New repository`
3. 填写:
   - Repository name: `smart-helmet-rtthread`
   - Description: `基于RT-Thread的智能安全帽多传感器监测系统`
   - 选择 `Public` (公开)
   - ✅ 勾选 `Add a README file`
4. 点击 `Create repository`

### 步骤2: 运行自动部署脚本

**双击运行**: `F:\RT\github_deploy\deploy.bat`

脚本会提示您输入:
1. GitHub用户名 (如: zhangsan)
2. 可能需要登录GitHub授权

等待脚本完成即可!

### 步骤3: 启用GitHub Pages

1. 访问您的仓库: `https://github.com/你的用户名/smart-helmet-rtthread`
2. 点击 `Settings`
3. 左侧菜单找到 `Pages`
4. 在 `Source` 下选择:
   - Branch: `main`
   - Folder: `/docs`
5. 点击 `Save`

**完成!** 🎉

---

## 🌐 查看在线演示

等待1-2分钟后,访问:

```
https://你的用户名.github.io/smart-helmet-rtthread/
```

**演示页面链接**:
- 📺 硬件连接图: `https://你的用户名.github.io/smart-helmet-rtthread/hardware_connection_diagram.html`
- 🖥️ RT-Thread控制台: `https://你的用户名.github.io/smart-helmet-rtthread/console_output.html`
- 📊 传感器数据: `https://你的用户名.github.io/smart-helmet-rtthread/smart_helmet_demo.html`
- ☁️ 华为云平台: `https://你的用户名.github.io/smart-helmet-rtthread/huawei_iot_dashboard.html`

---

## 📝 更新项目

修改文件后,双击运行: `F:\RT\github_deploy\update.bat`

---

## ❓ 遇到问题?

查看详细文档: `F:\RT\github_deploy\README.md`

---

**就是这么简单!** 😊
