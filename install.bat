@ECHO OFF

rem 检测注册表中是否有Python3.9信息。
echo ----------------------------------
echo 检测注册表……
reg query "hklm\software\Python\pythoncore\3.9" >nul 2>nul
echo %errorlevel%
if %errorlevel%==0 (echo 注册表检测到指定版本Python & GOTO check_python) else (echo 注册表未检测到指定版本Python!开始安装Python3.9…… & goto install_python)

:uninstall_python
echo 正在卸载Python！请稍候……
python-3.9.4-amd64.exe /quiet /uninstall
echo 卸载Python完成！

:check_python
rem 检测运行指定版本Python是否成功。
echo ----------------------------------
echo 检测指定版本Python运行状况……
py -3.9 --version >nul 2>nul
if %errorlevel%==0 (echo Python运行正常！ & goto set_path) else (echo Python运行异常！)
pause

:check_pip
rem 检测运行pip是否成功。
echo ----------------------------------
echo 检测pip运行状况……
@for /f "tokens=1" %%i in ('pip --version ^| findstr /C:"pip"') do ^
set PIPVER=%%i
@if "%PIPVER%" == "pip" (@echo Pip运行正常！) else ( echo Pip运行异常！& goto install_pip )

rem 安装pip可能失败，运行ez.py构建
:run_ezpy
cd pip-21.0.1
python ez.py >nul 2>nul
goto install_pip

:install_pip
cd pip-21.0.1
python setup.py install >nul 2>nul
if %errorlevel%==0 (echo Pip安装成功！) else (echo pip安装失败！& goto run_ezpy )
setx path "%path%;C:\Program Files\Python39\Scripts"
rem 安装必须的包
pip install np
pip install matplotlib
pause
goto:eof

:set_path
setx path "%path%;C:\Program Files\Python39;"
goto check_pip

:install_python
rem 采用静默模式安装Python。
echo ----------------------------------
echo 开始安装Python，请稍候……
python-3.9.4-amd64.exe /quiet InstallAllUsers=1 PrependPath=1
if %errorlevel%==0 (echo Python3.9安装成功！& goto check_python) else echo (Python安装失败！) 

