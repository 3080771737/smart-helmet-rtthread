@echo off
chcp 65001 >nul
echo ========================================
echo   智能安全帽项目 - GitHub自动部署脚本
echo ========================================
echo.

REM 检查Git是否安装
where git >nul 2>&1
if %errorlevel% neq 0 (
    echo [错误] 未检测到Git，请先安装Git！
    echo 下载地址: https://git-scm.com/download/win
    pause
    exit /b 1
)

echo [1/8] 检查Git配置...
git config --global user.name >nul 2>&1
if %errorlevel% neq 0 (
    echo [警告] Git用户名未配置
    set /p USERNAME="请输入您的GitHub用户名: "
    git config --global user.name "%USERNAME%"

    set /p EMAIL="请输入您的邮箱: "
    git config --global user.email "%EMAIL%"
    echo [完成] Git配置已保存
) else (
    echo [完成] Git已配置
)

echo.
echo [2/8] 创建项目目录结构...

REM 创建docs目录
if not exist "docs" mkdir docs

REM 创建documentation目录
if not exist "documentation" mkdir documentation

REM 创建applications目录
if not exist "applications" mkdir applications

echo [完成] 目录结构已创建

echo.
echo [3/8] 复制项目文件...

REM 复制RT-Thread主程序
if exist "F:\RT\zhiliao\sdk-bsp-stm32h7r-realthread-artpi2-master\projects\art_pi2_smart_helmet\applications\main.c" (
    copy /Y "F:\RT\zhiliao\sdk-bsp-stm32h7r-realthread-artpi2-master\projects\art_pi2_smart_helmet\applications\main.c" "applications\main.c" >nul
    echo [完成] 复制 main.c
) else (
    echo [警告] 未找到 main.c
)

REM 复制RT-Thread配置文件
if exist "F:\RT\zhiliao\sdk-bsp-stm32h7r-realthread-artpi2-master\projects\art_pi2_smart_helmet\rtconfig.h" (
    copy /Y "F:\RT\zhiliao\sdk-bsp-stm32h7r-realthread-artpi2-master\projects\art_pi2_smart_helmet\rtconfig.h" "rtconfig.h" >nul
    echo [完成] 复制 rtconfig.h
)

if exist "F:\RT\zhiliao\sdk-bsp-stm32h7r-realthread-artpi2-master\projects\art_pi2_smart_helmet\.config" (
    copy /Y "F:\RT\zhiliao\sdk-bsp-stm32h7r-realthread-artpi2-master\projects\art_pi2_smart_helmet\.config" ".config" >nul
    echo [完成] 复制 .config
)

if exist "F:\RT\zhiliao\sdk-bsp-stm32h7r-realthread-artpi2-master\projects\art_pi2_smart_helmet\SConscript" (
    copy /Y "F:\RT\zhiliao\sdk-bsp-stm32h7r-realthread-artpi2-master\projects\art_pi2_smart_helmet\SConscript" "SConscript" >nul
    echo [完成] 复制 SConscript
)

if exist "F:\RT\zhiliao\sdk-bsp-stm32h7r-realthread-artpi2-master\projects\art_pi2_smart_helmet\SConstruct" (
    copy /Y "F:\RT\zhiliao\sdk-bsp-stm32h7r-realthread-artpi2-master\projects\art_pi2_smart_helmet\SConstruct" "SConstruct" >nul
    echo [完成] 复制 SConstruct
)

REM 复制HTML演示文件到docs目录
if exist "F:\RT\hardware_connection_diagram.html" (
    copy /Y "F:\RT\hardware_connection_diagram.html" "docs\hardware_connection_diagram.html" >nul
    echo [完成] 复制 硬件连接图
)

if exist "F:\RT\console_output.html" (
    copy /Y "F:\RT\console_output.html" "docs\console_output.html" >nul
    echo [完成] 复制 控制台输出
)

if exist "F:\RT\smart_helmet_demo.html" (
    copy /Y "F:\RT\smart_helmet_demo.html" "docs\smart_helmet_demo.html" >nul
    echo [完成] 复制 传感器演示
)

if exist "F:\RT\huawei_iot_dashboard.html" (
    copy /Y "F:\RT\huawei_iot_dashboard.html" "docs\huawei_iot_dashboard.html" >nul
    echo [完成] 复制 华为云演示
)

REM 复制文档
if exist "F:\RT\smart_helmet_rtthread_submission.md" (
    copy /Y "F:\RT\smart_helmet_rtthread_submission.md" "documentation\smart_helmet_rtthread_submission.md" >nul
    echo [完成] 复制 提交文档
)

if exist "F:\RT\HARDWARE_CONNECTION_TABLE.md" (
    copy /Y "F:\RT\HARDWARE_CONNECTION_TABLE.md" "documentation\HARDWARE_CONNECTION_TABLE.md" >nul
    echo [完成] 复制 硬件连接表
)

echo.
echo [4/8] 初始化Git仓库...

if not exist ".git" (
    git init >nul 2>&1
    echo [完成] Git仓库已初始化
) else (
    echo [跳过] Git仓库已存在
)

echo.
echo [5/8] 添加文件到Git...
git add . >nul 2>&1
echo [完成] 文件已添加

echo.
echo [6/8] 提交到本地仓库...
git commit -m "Initial commit: Smart Helmet RT-Thread Project" >nul 2>&1
if %errorlevel% equ 0 (
    echo [完成] 本地提交成功
) else (
    echo [信息] 没有新的更改需要提交
)

echo.
echo [7/8] 配置远程仓库...
set /p GITHUB_USERNAME="请输入您的GitHub用户名: "

REM 检查远程仓库是否已配置
git remote | findstr "origin" >nul 2>&1
if %errorlevel% equ 0 (
    echo [信息] 远程仓库已存在，将更新URL
    git remote set-url origin https://github.com/%GITHUB_USERNAME%/smart-helmet-rtthread.git
) else (
    git remote add origin https://github.com/%GITHUB_USERNAME%/smart-helmet-rtthread.git
)
echo [完成] 远程仓库: https://github.com/%GITHUB_USERNAME%/smart-helmet-rtthread

echo.
echo [8/8] 推送到GitHub...
echo [提示] 如果是第一次推送，可能需要登录GitHub进行授权
echo.

git branch -M main >nul 2>&1
git push -u origin main

if %errorlevel% equ 0 (
    echo.
    echo ========================================
    echo   ✅ 部署成功！
    echo ========================================
    echo.
    echo 🎉 您的项目已成功推送到GitHub！
    echo.
    echo 📁 GitHub仓库地址:
    echo    https://github.com/%GITHUB_USERNAME%/smart-helmet-rtthread
    echo.
    echo 📋 下一步操作:
    echo    1. 访问上面的仓库地址
    echo    2. 点击 Settings → Pages
    echo    3. 在Source下选择:
    echo       - Branch: main
    echo       - Folder: /docs
    echo    4. 点击Save
    echo.
    echo 🌐 几分钟后，您的在线演示将发布到:
    echo    https://%GITHUB_USERNAME%.github.io/smart-helmet-rtthread/
    echo.
    echo ========================================
) else (
    echo.
    echo ========================================
    echo   ❌ 推送失败
    echo ========================================
    echo.
    echo 可能的原因:
    echo 1. GitHub仓库尚未创建
    echo    → 访问 https://github.com/new 创建仓库
    echo    → 仓库名称必须是: smart-helmet-rtthread
    echo.
    echo 2. 权限验证失败
    echo    → 需要配置Personal Access Token
    echo    → 访问 https://github.com/settings/tokens
    echo    → 生成新的Token并勾选repo权限
    echo.
    echo 3. 网络连接问题
    echo    → 检查网络连接
    echo    → 尝试访问 https://github.com
    echo.
    echo ========================================
)

echo.
pause
