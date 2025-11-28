@echo off
chcp 65001 >nul
echo ========================================
echo   推送README更新到GitHub
echo ========================================
echo.

cd /d F:\RT\github_deploy

echo [1/3] 添加README.md...
git add README.md

echo [2/3] 提交更改...
git commit -m "Update README: 修改为项目介绍版本"

echo [3/3] 推送到GitHub...
git push

if %errorlevel% equ 0 (
    echo.
    echo ========================================
    echo   ✅ README更新成功！
    echo ========================================
    echo.
    echo 访问查看: https://github.com/3080771737/smart-helmet-rtthread
    echo.
) else (
    echo.
    echo ========================================
    echo   ❌ 推送失败
    echo ========================================
)

pause
