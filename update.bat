@echo off
chcp 65001 >nul
echo ========================================
echo   快速更新脚本
echo ========================================
echo.

REM 检查是否在Git仓库中
if not exist ".git" (
    echo [错误] 当前目录不是Git仓库！
    echo 请先运行 deploy.bat 进行初始部署
    pause
    exit /b 1
)

echo [1/4] 添加修改的文件...
git add .
echo [完成]

echo.
echo [2/4] 提交更改...
set /p COMMIT_MSG="请输入提交说明 (直接回车使用默认): "
if "%COMMIT_MSG%"=="" (
    set COMMIT_MSG=Update: 更新项目文件
)

git commit -m "%COMMIT_MSG%"
if %errorlevel% equ 0 (
    echo [完成] 提交成功
) else (
    echo [信息] 没有新的更改需要提交
    pause
    exit /b 0
)

echo.
echo [3/4] 推送到GitHub...
git push

if %errorlevel% equ 0 (
    echo [完成] 推送成功
    echo.
    echo ========================================
    echo   ✅ 更新完成！
    echo ========================================
    echo.
    echo 您的更改已推送到GitHub
    echo GitHub Pages将在1-2分钟后更新
    echo.
) else (
    echo [错误] 推送失败
    echo 请检查网络连接或GitHub权限
)

echo.
pause
