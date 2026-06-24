#!/bin/bash
# STOAT-HACKER v4.0.0 Installation Script
# Run: ./setup.sh

set -e

echo "🦡 STOAT-HACKER v4.0.0 - Installation"
echo "========================================"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Check Python version
echo -e "${BLUE}📌 Checking Python version...${NC}"
python_version=$(python3 --version 2>&1 | cut -d' ' -f2)
if [[ "$python_version" < "3.7" ]]; then
    echo -e "${RED}❌ Python 3.7+ required. Found: $python_version${NC}"
    exit 1
fi
echo -e "${GREEN}✅ Python $python_version found${NC}"

# Create directories
echo -e "${BLUE}📁 Creating directories...${NC}"
mkdir -p .stoat
mkdir -p stoat_reports
mkdir -p stoat_reports/graphics
mkdir -p temp
mkdir -p logs
mkdir -p payloads

# Install system dependencies
echo -e "${BLUE}📦 Installing system dependencies...${NC}"
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo -e "${YELLOW}🔄 Updating package list...${NC}"
    sudo apt-get update -qq
    
    echo -e "${YELLOW}📦 Installing required packages...${NC}"
    sudo apt-get install -y -qq \
        python3-pip \
        python3-dev \
        python3-venv \
        nmap \
        nikto \
        curl \
        netcat-openbsd \
        whois \
        dnsutils \
        traceroute \
        iptables \
        wkhtmltopdf \
        git \
        build-essential \
        libssl-dev \
        libffi-dev \
        tcpdump \
        wireshark \
        sqlite3
        
    # Install pyinstaller for EXE generation
    if ! command -v pyinstaller &> /dev/null; then
        pip3 install pyinstaller
    fi
    
elif [[ "$OSTYPE" == "darwin"* ]]; then
    echo -e "${YELLOW}🍎 macOS detected...${NC}"
    if ! command -v brew &> /dev/null; then
        echo -e "${YELLOW}📦 Installing Homebrew...${NC}"
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    
    brew update
    brew install nmap nikto curl netcat whois dnsutils traceroute wkhtmltopdf sqlite3
fi

# Create virtual environment
echo -e "${BLUE}🐍 Creating virtual environment...${NC}"
python3 -m venv stoat_env
source stoat_env/bin/activate

# Install Python dependencies
echo -e "${BLUE}📦 Installing Python dependencies...${NC}"
pip install --upgrade pip -q
pip install -r requirements.txt -q

# Install optional dependencies
echo -e "${YELLOW}🔧 Installing optional dependencies...${NC}"
pip install pyinstaller python-docx reportlab qrcode pyshorteners selenium webdriver-manager --quiet

# Verify installation
echo -e "${BLUE}🔍 Verifying installation...${NC}"
python3 -c "import scapy, paramiko, flask, pynput, discord, telethon, slack_sdk" 2>/dev/null && echo -e "${GREEN}✅ All core modules imported successfully${NC}" || echo -e "${YELLOW}⚠️ Some modules may be missing${NC}"

# Create configuration
echo -e "${BLUE}⚙️ Creating default configuration...${NC}"
cat > .stoat/config.json << EOF
{
    "version": "4.0.0",
    "auto_start": false,
    "auto_block_enabled": true,
    "auto_block_threshold": 5,
    "scan_timeout": 30,
    "report_format": "html",
    "generate_graphics": true,
    "keylogger_enabled": true,
    "keylogger_port": 4444,
    "keylogger_interval": 30,
    "payload_callback_host": "localhost",
    "payload_callback_port": 5555,
    "web": {
        "enabled": true,
        "port": 5000,
        "host": "0.0.0.0",
        "secret_key": "",
        "require_auth": false
    },
    "monitoring": {
        "enabled": true,
        "port_scan_threshold": 10,
        "syn_flood_threshold": 100,
        "http_flood_threshold": 200
    },
    "ddos": {
        "enabled": true,
        "max_threads": 100,
        "default_duration": 30
    },
    "agent": {
        "enabled": false,
        "server": "localhost",
        "port": 5555,
        "heartbeat": 60
    }
}
EOF

echo -e "${GREEN}✅ Configuration created in .stoat/config.json${NC}"

# Setup systemd service (Linux only)
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo -e "${BLUE}⚙️ Setting up systemd service...${NC}"
    sudo cp stoat.service /etc/systemd/system/
    sudo systemctl daemon-reload
    echo -e "${GREEN}✅ Systemd service installed${NC}"
    echo -e "${YELLOW}   Start with: sudo systemctl start stoat${NC}"
    echo -e "${YELLOW}   Enable with: sudo systemctl enable stoat${NC}"
fi

# Create launcher script
echo -e "${BLUE}📝 Creating launcher script...${NC}"
cat > stoat.sh << 'EOF'
#!/bin/bash
cd "$(dirname "$0")"
source stoat_env/bin/activate
python3 stoat.py "$@"
EOF
chmod +x stoat.sh

# Create alias for easy access
echo -e "${GREEN}✅ Installation complete!${NC}"
echo ""
echo -e "${BLUE}🚀 To run STOAT-HACKER:${NC}"
echo -e "  ./stoat.sh"
echo -e "  or"
echo -e "  source stoat_env/bin/activate && python3 stoat.py"
echo ""
echo -e "${BLUE}📁 Key directories:${NC}"
echo -e "  .stoat/          - Configuration and data"
echo -e "  stoat_reports/   - Generated reports"
echo -e "  logs/            - Log files"
echo -e "  payloads/        - Generated payloads"
echo ""
echo -e "${BLUE}💡 Commands:${NC}"
echo -e "  ./stoat.sh -h    - Show help"
echo -e "  ./stoat.sh help  - Show command list"
echo ""
echo -e "${GREEN}🦡 Happy Hacking!${NC}"