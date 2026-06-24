@echo off
REM STOAT-HACKER v4.0.0 Installation Script (Windows)
REM Run: setup.bat

echo 🦡 STOAT-HACKER v4.0.0 - Installation
echo ========================================

:: Check Python version
echo 📌 Checking Python version...
python --version 2>nul || (
    echo ❌ Python not found. Please install Python 3.7+
    pause
    exit /b 1
)

:: Create directories
echo 📁 Creating directories...
mkdir .stoat 2>nul
mkdir stoat_reports 2>nul
mkdir stoat_reports\graphics 2>nul
mkdir temp 2>nul
mkdir logs 2>nul
mkdir payloads 2>nul

:: Create virtual environment
echo 🐍 Creating virtual environment...
python -m venv stoat_env
call stoat_env\Scripts\activate

:: Install dependencies
echo 📦 Installing Python dependencies...
pip install --upgrade pip -q
pip install -r requirements.txt -q

:: Install optional dependencies
echo 🔧 Installing optional dependencies...
pip install pyinstaller python-docx reportlab qrcode pyshorteners selenium webdriver-manager --quiet

:: Create configuration
echo ⚙️ Creating default configuration...
type nul > .stoat\config.json
echo {
echo     "version": "4.0.0",
echo     "auto_start": false,
echo     "auto_block_enabled": true,
echo     "auto_block_threshold": 5,
echo     "scan_timeout": 30,
echo     "report_format": "html",
echo     "generate_graphics": true,
echo     "keylogger_enabled": true,
echo     "keylogger_port": 4444,
echo     "keylogger_interval": 30,
echo     "payload_callback_host": "localhost",
echo     "payload_callback_port": 5555,
echo     "web": {
echo         "enabled": true,
echo         "port": 5000,
echo         "host": "0.0.0.0",
echo         "secret_key": "",
echo         "require_auth": false
echo     },
echo     "monitoring": {
echo         "enabled": true,
echo         "port_scan_threshold": 10,
echo         "syn_flood_threshold": 100,
echo         "http_flood_threshold": 200
echo     },
echo     "ddos": {
echo         "enabled": true,
echo         "max_threads": 100,
echo         "default_duration": 30
echo     },
echo     "agent": {
echo         "enabled": false,
echo         "server": "localhost",
echo         "port": 5555,
echo         "heartbeat": 60
echo     }
echo } > .stoat\config.json

:: Create launcher script
echo 📝 Creating launcher script...
echo @echo off > stoat.bat
echo cd %~dp0 >> stoat.bat
echo call stoat_env\Scripts\activate >> stoat.bat
echo python stoat.py %%* >> stoat.bat

echo.
echo ✅ Installation complete!
echo.
echo 🚀 To run STOAT-HACKER:
echo   stoat.bat
echo.
echo 🦡 Happy Hacking!
pause