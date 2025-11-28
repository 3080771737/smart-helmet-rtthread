@echo off
chcp 65001 >nul
echo ========================================
echo   Git冲突一键修复脚本
echo ========================================
echo.

echo [提示] 此脚本将解决Git合并冲突并强制推送
echo [警告] 将使用本地版本覆盖GitHub上的README.md
echo.

pause

echo.
echo [1/3] 中止当前合并...
git merge --abort >nul 2>&1

echo [2/3] 强制推送本地版本到GitHub...
git push -u origin main --force

if %errorlevel% equ 0 (
    echo.
    echo ========================================
    echo   ✅ 修复成功！
    echo ========================================
    echo.
    echo 🎉 项目已成功推送到GitHub！
    echo.
    echo 📁 GitHub仓库地址:
    for /f "tokens=2 delims=/" %%a in ('git remote get-url origin') do (
        for /f "tokens=1 delims=/" %%b in ("%%a") do (
            echo    https://github.com/%%b/smart-helmet-rtthread
        )
    )
    echo.
    echo 📋 下一步操作:
    echo    1. 访问仓库地址
    echo    2. 点击 Settings → Pages
    echo    3. 选择 Branch: main, Folder: /docs
    echo    4. 点击Save
    echo.
    echo 🌐 几分钟后，在线演示将发布到:
    for /f "tokens=2 delims=/" %%a in ('git remote get-url origin') do (
        for /f "tokens=1 delims=/" %%b in ("%%a") do (
            echo    https://%%b.github.io/smart-helmet-rtthread/
        )
    )
    echo.
    echo ========================================
) else (
    echo.
    echo ========================================
    echo   ❌ 推送失败
    echo ========================================
    echo.
    echo 可能的原因:
    echo 1. 网络连接问题
    echo    → 检查网络连接
    echo.
    echo 2. GitHub���限问题
    echo    → 需要配置Personal Access Token
    echo    → 访问 https://github.com/settings/tokens
    echo    → 生成Token并在推送时使用
    echo.
    echo 3. 仓库不存在
    echo    → 确认已在GitHub创建仓库
    echo    → 仓库名称: smart-helmet-rtthread
    echo.
    echo ========================================
)

echo.
pause
