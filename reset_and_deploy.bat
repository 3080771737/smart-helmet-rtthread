@echo off
chcp 65001 >nul
echo ========================================
echo   GitHub部署完全重置脚本
echo ========================================
echo.

echo [提示] 此脚本将完全重置并重新部署项目
echo [警告] 将删除本地Git历史并强制推送到GitHub
echo.

set /p CONFIRM="确认要继续吗? (输入YES继续): "
if not "%CONFIRM%"=="YES" (
    echo 已取消操作
    pause
    exit /b 0
)

echo.
echo [1/6] 删除本地Git仓库...
if exist ".git" (
    rmdir /s /q .git
    echo [完成] 已删除.git目录
) else (
    echo [跳过] .git目录不存在
)

echo.
echo [2/6] 重新初始化Git仓库...
git init
git branch -M main
echo [完成] Git仓库已初始化

echo.
echo [3/6] 添加所有文件...
git add .
echo [完成] 文件已添加

echo.
echo [4/6] 创建初始提交...
git commit -m "Initial commit: Smart Helmet RT-Thread Project"
echo [完成] 提交完成

echo.
echo [5/6] 配置远程仓库...
set /p GITHUB_USERNAME="请输入您的GitHub用户名: "
git remote add origin https://github.com/%GITHUB_USERNAME%/smart-helmet-rtthread.git
echo [完成] 远程仓库: https://github.com/%GITHUB_USERNAME%/smart-helmet-rtthread

echo.
echo [6/6] 强制推送到GitHub...
echo [提示] 将覆盖GitHub上的所有内容
echo.

git push -u origin main --force

if %errorlevel% equ 0 (
    echo.
    echo ========================================
    echo   ✅ 重置部署成功！
    echo ========================================
    echo.
    echo 🎉 项目已成功推送到GitHub！
    echo.
    echo 📁 GitHub仓库: https://github.com/%GITHUB_USERNAME%/smart-helmet-rtthread
    echo 🌐 在线演示: https://%GITHUB_USERNAME%.github.io/smart-helmet-rtthread/
    echo.
    echo 📋 下一步: 启用GitHub Pages
    echo    1. 访问: https://github.com/%GITHUB_USERNAME%/smart-helmet-rtthread/settings/pages
    echo    2. Source选择: Branch: main, Folder: /docs
    echo    3. 点击Save
    echo.
    echo ========================================
) else (
    echo.
    echo ========================================
    echo   ❌ 推送失败
    echo ========================================
    echo.
    echo 请检查:
    echo 1. 网络连接
    echo 2. GitHub仓库是否已创建
    echo 3. 用户名是否正确
    echo.
    echo ========================================
)

echo.
pause
