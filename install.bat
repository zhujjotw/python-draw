@ECHO OFF

rem ���ע������Ƿ���Python3.9��Ϣ��
echo ----------------------------------
echo ���ע�����
reg query "hklm\software\Python\pythoncore\3.9" >nul 2>nul
echo %errorlevel%
if %errorlevel%==0 (echo ע����⵽ָ���汾Python & GOTO check_python) else (echo ע���δ��⵽ָ���汾Python!��ʼ��װPython3.9���� & goto install_python)

:uninstall_python
echo ����ж��Python�����Ժ򡭡�
python-3.9.4-amd64.exe /quiet /uninstall
echo ж��Python��ɣ�

:check_python
rem �������ָ���汾Python�Ƿ�ɹ���
echo ----------------------------------
echo ���ָ���汾Python����״������
py -3.9 --version >nul 2>nul
if %errorlevel%==0 (echo Python���������� & goto set_path) else (echo Python�����쳣��)
pause

:check_pip
rem �������pip�Ƿ�ɹ���
echo ----------------------------------
echo ���pip����״������
@for /f "tokens=1" %%i in ('pip --version ^| findstr /C:"pip"') do ^
set PIPVER=%%i
@if "%PIPVER%" == "pip" (@echo Pip����������) else ( echo Pip�����쳣��& goto install_pip )

rem ��װpip����ʧ�ܣ�����ez.py����
:run_ezpy
cd pip-21.0.1
python ez.py >nul 2>nul
goto install_pip

:install_pip
cd pip-21.0.1
python setup.py install >nul 2>nul
if %errorlevel%==0 (echo Pip��װ�ɹ���) else (echo pip��װʧ�ܣ�& goto run_ezpy )
setx path "%path%;C:\Program Files\Python39\Scripts"
rem ��װ����İ�
pip install np
pip install matplotlib
pause
goto:eof

:set_path
setx path "%path%;C:\Program Files\Python39;"
goto check_pip

:install_python
rem ���þ�Ĭģʽ��װPython��
echo ----------------------------------
echo ��ʼ��װPython�����Ժ򡭡�
python-3.9.4-amd64.exe /quiet InstallAllUsers=1 PrependPath=1
if %errorlevel%==0 (echo Python3.9��װ�ɹ���& goto check_python) else echo (Python��װʧ�ܣ�) 

