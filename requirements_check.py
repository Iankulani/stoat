#!/usr/bin/env python3
"""
STOAT-HACKER v4.0.0 - Requirements Checker
Checks all dependencies and system requirements
"""

import sys
import os
import subprocess
import importlib
import platform

class Colors:
    GREEN = '\033[92m'
    RED = '\033[91m'
    YELLOW = '\033[93m'
    BLUE = '\033[94m'
    RESET = '\033[0m'

REQUIRED_PYTHON_VERSION = (3, 7)
REQUIRED_PACKAGES = [
    'requests',
    'psutil',
    'colorama',
    'cryptography',
    'paramiko',
    'flask',
    'flask_socketio',
    'flask_cors',
    'scapy',
    'pynput',
    'discord',
    'telethon',
    'slack_sdk',
    'matrix_client',
    'whois',
    'matplotlib',
    'seaborn',
    'numpy',
    'docx',
    'reportlab',
    'qrcode',
    'pyshorteners',
    'selenium',
    'googleapiclient',
]

REQUIRED_TOOLS = [
    'nmap',
    'curl',
    'whois',
    'dig',
    'traceroute',
    'nikto',
]

def check_python_version():
    """Check Python version"""
    version = sys.version_info
    if version >= REQUIRED_PYTHON_VERSION:
        print(f"{Colors.GREEN}✅ Python {version.major}.{version.minor}.{version.micro}{Colors.RESET}")
        return True
    print(f"{Colors.RED}❌ Python {REQUIRED_PYTHON_VERSION[0]}.{REQUIRED_PYTHON_VERSION[1]}+ required{Colors.RESET}")
    return False

def check_package(package):
    """Check if a Python package is installed"""
    try:
        importlib.import_module(package)
        return True
    except ImportError:
        return False

def check_tool(tool):
    """Check if a system tool is available"""
    return subprocess.run(['which', tool], capture_output=True).returncode == 0

def main():
    print(f"{Colors.BLUE}🦡 STOAT-HACKER v4.0.0 - Requirements Check{Colors.RESET}")
    print("=" * 50)
    
    # Python version
    print(f"\n{Colors.BLUE}🐍 Python:{Colors.RESET}")
    check_python_version()
    
    # Operating System
    print(f"\n{Colors.BLUE}💻 System:{Colors.RESET}")
    print(f"  OS: {platform.system()} {platform.release()}")
    print(f"  Architecture: {platform.machine()}")
    
    # Python packages
    print(f"\n{Colors.BLUE}📦 Python Packages:{Colors.RESET}")
    missing = []
    for package in REQUIRED_PACKAGES:
        if check_package(package):
            print(f"  {Colors.GREEN}✅ {package}{Colors.RESET}")
        else:
            print(f"  {Colors.RED}❌ {package} (missing){Colors.RESET}")
            missing.append(package)
    
    # System tools
    print(f"\n{Colors.BLUE}🔧 System Tools:{Colors.RESET}")
    missing_tools = []
    for tool in REQUIRED_TOOLS:
        if check_tool(tool):
            print(f"  {Colors.GREEN}✅ {tool}{Colors.RESET}")
        else:
            print(f"  {Colors.RED}❌ {tool} (not found){Colors.RESET}")
            missing_tools.append(tool)
    
    # Database
    print(f"\n{Colors.BLUE}💾 Database:{Colors.RESET}")
    try:
        import sqlite3
        print(f"  {Colors.GREEN}✅ SQLite3 available{Colors.RESET}")
    except:
        print(f"  {Colors.RED}❌ SQLite3 not available{Colors.RESET}")
    
    # Directory structure
    print(f"\n{Colors.BLUE}📁 Directories:{Colors.RESET}")
    dirs = ['.stoat', 'stoat_reports', 'logs', 'temp', 'payloads']
    for d in dirs:
        if os.path.exists(d):
            print(f"  {Colors.GREEN}✅ {d}{Colors.RESET}")
        else:
            print(f"  {Colors.YELLOW}⚠️ {d} (missing - will be created){Colors.RESET}")
    
    # Summary
    print("\n" + "=" * 50)
    print(f"{Colors.BLUE}📊 Summary:{Colors.RESET}")
    
    if missing:
        print(f"{Colors.RED}❌ Missing Python packages: {', '.join(missing)}{Colors.RESET}")
        print(f"   Install with: pip install {' '.join(missing)}{Colors.RESET}")
    
    if missing_tools:
        print(f"{Colors.YELLOW}⚠️ Missing system tools: {', '.join(missing_tools)}{Colors.RESET}")
        print("   Install with: sudo apt-get install " + ' '.join(missing_tools) + " (Linux)")
    
    if not missing and not missing_tools:
        print(f"{Colors.GREEN}✅ All requirements satisfied!{Colors.RESET}")
        print(f"\n{Colors.BLUE}🚀 Run: python3 stoat.py{Colors.RESET}")
    else:
        print(f"\n{Colors.YELLOW}⚠️ Some requirements are missing. Run setup.sh to install.{Colors.RESET}")

if __name__ == "__main__":
    main()