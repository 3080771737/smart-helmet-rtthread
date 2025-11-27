# 🚀 GitHub部署指南

> **项目**: 基于RT-Thread的智能安全帽监测系统
> **目标**: 部署到GitHub并启用GitHub Pages在线演示

---

## 📋 部署前准备

### 1. 安装Git

**Windows系统**:
1. 下载Git: https://git-scm.com/download/win
2. 安装时选择默认选项
3. 安装完成后,右键桌面 → 选择"Git Bash Here"测试

**验证安装**:
```bash
git --version
# 应该显示: git version 2.x.x
```

### 2. 配置Git

```bash
# 设置用户名和邮箱
git config --global user.name "您的名字"
git config --global user.email "your_email@example.com"

# 验证配置
git config --list
```

### 3. GitHub账号准备

- 注册GitHub账号: https://github.com/signup
- 登录GitHub

---

## 🎯 部署步骤

### 步骤1: 创建GitHub仓库

#### 方法A: 网页创建(推荐)

1. 登录GitHub
2. 点击右上角 `+` → `New repository`
3. 填写信息:
   - **Repository name**: `smart-helmet-rtthread`
   - **Description**: `基于RT-Thread的智能安全帽多传感器监测系统`
   - **Public** (选择公开,GitHub Pages需要)
   - ✅ 勾选 `Add a README file`
   - 选择 `License`: `Apache License 2.0`
4. 点击 `Create repository`

#### 方法B: Git命令行创建

```bash
# 需要先安装GitHub CLI
# 下载: https://cli.github.com/

gh repo create smart-helmet-rtthread --public --description "基于RT-Thread的智能安全帽多传感器监测系统"
```

---

### 步骤2: 运行自动部署脚本

#### Windows用户

**方式1: 双击运行**
```
双击运行: F:\RT\github_deploy\deploy.bat
```

**方式2: 命令行运行**
```bash
cd F:\RT\github_deploy
deploy.bat
```

**脚本会自动执行**:
1. 创建本地Git仓库
2. 整理项目文件
3. 复制演示HTML到docs目录
4. 提交所有文件
5. 推送到GitHub

#### 运行过程中的提示

**第1次会要求输入GitHub用户名**:
```
请输入您的GitHub用户名:
> your_username   (输入您的用户名)
```

**然后会要求验证身份**:
- 如果是第一次推送,会弹出GitHub登录窗口
- 登录您的GitHub账号
- 授权Git访问

---

### 步骤3: 启用GitHub Pages

#### 方法A: 网页配置(推荐)

1. 打开您的仓库: `https://github.com/your_username/smart-helmet-rtthread`
2. 点击 `Settings` (设置)
3. 左侧菜单找到 `Pages`
4. 在 `Source` 下:
   - **Branch**: 选择 `main`
   - **Folder**: 选择 `/docs`
5. 点击 `Save`
6. 等待1-2分钟,页面会显示:
   ```
   ✅ Your site is published at https://your_username.github.io/smart-helmet-rtthread/
   ```

#### 方法B: 使用命令行

```bash
cd F:\RT\github_deploy
enable_pages.bat
```

---

### 步骤4: 验证部署

#### 检查在线演示链接

访问以下链接(替换 `your_username` 为您的GitHub用户名):

- **📺 硬件连接图**:
  ```
  https://your_username.github.io/smart-helmet-rtthread/hardware_connection_diagram.html
  ```

- **🖥️ RT-Thread控制台**:
  ```
  https://your_username.github.io/smart-helmet-rtthread/console_output.html
  ```

- **📊 传感器数据演示**:
  ```
  https://your_username.github.io/smart-helmet-rtthread/smart_helmet_demo.html
  ```

- **☁️ 华为云IoT平台**:
  ```
  https://your_username.github.io/smart-helmet-rtthread/huawei_iot_dashboard.html
  ```

- **🏠 演示索引页**:
  ```
  https://your_username.github.io/smart-helmet-rtthread/
  ```

---

## 📝 手动部署步骤(备用方案)

如果自动脚本出现问题,可以手动执行以下命令:

### 1. 初始化Git仓库

```bash
cd F:\RT\github_deploy
git init
```

### 2. 添加远程仓库

```bash
# 替换 your_username 为您的GitHub用户名
git remote add origin https://github.com/your_username/smart-helmet-rtthread.git
```

### 3. 添加文件到Git

```bash
git add .
```

### 4. 提交

```bash
git commit -m "Initial commit: Smart Helmet RT-Thread Project"
```

### 5. 推送到GitHub

```bash
git branch -M main
git push -u origin main
```

---

## 🔄 更新项目

### 修改文件后重新部署

```bash
cd F:\RT\github_deploy

# 查看修改的文件
git status

# 添加所有修改
git add .

# 提交修改
git commit -m "Update: 更新说明"

# 推送到GitHub
git push
```

### 使用快速更新脚本

```bash
cd F:\RT\github_deploy
update.bat
```

---

## 🎨 自定义演示页面

### 修改索引页

编辑 `F:\RT\github_deploy\docs\index.html`:

```html
<!-- 修改项目标题 -->
<h1>您的项目名称</h1>

<!-- 修改作者信息 -->
<p>作者: 您的名字</p>
```

修改后运行:
```bash
update.bat
```

---

## 📂 项目结构

```
F:\RT\github_deploy\
├── README.md                          # GitHub仓库首页
├── LICENSE                            # 开源协议
├── .gitignore                         # Git忽略文件
├── deploy.bat                         # 自动部署脚本(Windows)
├── update.bat                         # 快速更新脚本
├── enable_pages.bat                   # 启用GitHub Pages
├── applications/
│   └── main.c                         # RT-Thread主程序
├── board/                             # 板级支持包
├── rt-thread/                         # RT-Thread源码(符号链接)
├── libraries/                         # STM32库(符号链接)
├── rtconfig.h                         # RT-Thread配置
├── .config                            # Kconfig配置
├── SConscript                         # SCons构建脚本
├── SConstruct                         # SCons主构建文件
├── mklinks.bat                        # 符号链接脚本
├── docs/                              # GitHub Pages目录 ⭐
│   ├── index.html                     # 演示索引页
│   ├── hardware_connection_diagram.html
│   ├── console_output.html
│   ├── smart_helmet_demo.html
│   └── huawei_iot_dashboard.html
└── documentation/                     # 文档目录
    ├── smart_helmet_rtthread_submission.md
    └── HARDWARE_CONNECTION_TABLE.md
```

---

## ❓ 常见问题

### Q1: Git推送失败,提示权限错误

**错误信息**:
```
remote: Permission to user/repo.git denied
fatal: unable to access 'https://github.com/...': The requested URL returned error: 403
```

**解决方案**:
```bash
# 方案A: 使用Personal Access Token
# 1. 访问: https://github.com/settings/tokens
# 2. Generate new token (classic)
# 3. 勾选 repo 权限
# 4. 生成并复制token
# 5. 推送时用token替代密码

# 方案B: 使用SSH
ssh-keygen -t ed25519 -C "your_email@example.com"
# 将公钥添加到GitHub: https://github.com/settings/keys
```

### Q2: GitHub Pages显示404

**原因**:
- Pages未启用
- 分支/目录选择错误
- 需要等待1-2分钟生效

**解决方案**:
1. 检查 `Settings` → `Pages` 配置
2. 确认选择了 `main` 分支和 `/docs` 目录
3. 等待几分钟后刷新

### Q3: HTML文件在GitHub上显示源码而不是页面

**原因**: 没有启用GitHub Pages

**解决方案**: 按照"步骤3: 启用GitHub Pages"操作

### Q4: 推送时要求输入用户名密码

**解决方案**:
```bash
# 配置Git记住凭证
git config --global credential.helper store

# 下次推送时输入用户名和Personal Access Token
# Token获取: https://github.com/settings/tokens
```

### Q5: 文件太大无法推送

**错误信息**:
```
remote: error: File xxx is 123.45 MB; this exceeds GitHub's file size limit of 100 MB
```

**解决方案**:
```bash
# 将大文件添加到.gitignore
echo "*.bin" >> .gitignore
echo "*.hex" >> .gitignore
echo "*.elf" >> .gitignore
git add .gitignore
git commit -m "Add .gitignore for large files"
```

---

## 🔐 隐私保护

### 敏感信息处理

在提交前检查:

- ❌ WiFi密码
- ❌ MQTT密钥
- ❌ API Token
- ❌ 邮箱地址(如不想公开)
- ❌ 电话号码

**建议**:
```c
// ❌ 错误做法
#define WIFI_SSID "MyHomeWiFi"
#define WIFI_PASSWORD "MyPassword123"

// ✅ 正确做法
#define WIFI_SSID "YOUR_WIFI_SSID"
#define WIFI_PASSWORD "YOUR_WIFI_PASSWORD"
```

---

## 📞 获取帮助

### 官方资源

- **Git官方文档**: https://git-scm.com/doc
- **GitHub文档**: https://docs.github.com
- **RT-Thread社区**: https://club.rt-thread.org

### 问题反馈

如果部署过程中遇到问题:
1. 检查本文档的"常见问题"章节
2. 在RT-Thread社区发帖求助
3. 在GitHub仓库提交Issue

---

## ✅ 部署完成检查清单

部署完成后,请检查:

- [ ] GitHub仓库已创建
- [ ] 代码已推送到GitHub
- [ ] GitHub Pages已启用
- [ ] 在线演示链接可以访问
- [ ] 所有HTML文件正常显示
- [ ] README.md显示正常
- [ ] 文档链接有效
- [ ] 个人信息已修改(不包含占位符)
- [ ] 敏感信息已移除

---

**祝您部署顺利!** 🎉

如有问题,请查看本文档的"常见问题"章节。
