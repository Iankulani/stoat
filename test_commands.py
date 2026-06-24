#!/usr/bin/env python3
"""
STOAT-HACKER v4.0.0 - Command Testing Suite
Tests all major commands and features
"""

import sys
import os
import json
import time
import subprocess
from pathlib import Path

# Colors
class Colors:
    GREEN = '\033[92m'
    RED = '\033[91m'
    YELLOW = '\033[93m'
    BLUE = '\033[94m'
    RESET = '\033[0m'

def run_test(name, command, expected_success=True):
    """Run a single test"""
    print(f"{Colors.BLUE}▶ Testing: {name}{Colors.RESET}")
    
    try:
        result = subprocess.run(
            ['python3', 'stoat.py', '-c', command],
            capture_output=True,
            text=True,
            timeout=30
        )
        
        if (result.returncode == 0) == expected_success:
            print(f"{Colors.GREEN}  ✅ PASSED{Colors.RESET}")
            return True
        else:
            print(f"{Colors.RED}  ❌ FAILED (exit code: {result.returncode}){Colors.RESET}")
            if result.stderr:
                print(f"  Error: {result.stderr[:200]}")
            return False
    except subprocess.TimeoutExpired:
        print(f"{Colors.RED}  ❌ TIMEOUT{Colors.RESET}")
        return False
    except Exception as e:
        print(f"{Colors.RED}  ❌ ERROR: {e}{Colors.RESET}")
        return False

def main():
    print(f"{Colors.BLUE}🦡 STOAT-HACKER v4.0.0 - Command Test Suite{Colors.RESET}")
    print("=" * 50)
    
    # Ensure stoat.py exists
    if not os.path.exists('stoat.py'):
        print(f"{Colors.RED}❌ stoat.py not found!{Colors.RESET}")
        sys.exit(1)
    
    tests = [
        # Basic commands
        ("Help", "help"),
        ("Status", "status"),
        ("System info", "system"),
        ("Ping test", "ping 127.0.0.1"),
        ("DNS lookup", "dns google.com"),
        ("Traceroute", "traceroute 8.8.8.8", False),  # May fail without network
        
        # Network tests
        ("Nmap quick", "nmap_quick 127.0.0.1"),
        ("Whois", "whois google.com"),
        ("Location", "location 8.8.8.8"),
        
        # Traffic tests (require scapy)
        ("Traffic types", "traffic_types"),
        ("Traffic status", "traffic_status"),
        
        # SSH tests (if available)
        ("SSH list", "ssh_list"),
        
        # Payload tests
        ("Payload list", "payload_list"),
        ("Generate EXE payload", "payload_exe test_payload"),
        
        # Social engineering
        ("Phishing list", "phish_list"),
        
        # Database
        ("History", "history"),
        ("Threats", "threats"),
        
        # DDoS (safe test)
        ("DDoS status", "ddos_status"),
    ]
    
    passed = 0
    failed = 0
    
    for name, command, *expected in tests:
        expected_success = expected[0] if expected else True
        if run_test(name, command, expected_success):
            passed += 1
        else:
            failed += 1
        time.sleep(0.5)
    
    print("=" * 50)
    print(f"{Colors.BLUE}📊 Results:{Colors.RESET}")
    print(f"  {Colors.GREEN}✅ Passed: {passed}{Colors.RESET}")
    print(f"  {Colors.RED}❌ Failed: {failed}{Colors.RESET}")
    print(f"  Total: {passed + failed}")
    
    if failed == 0:
        print(f"\n{Colors.GREEN}🦡 All tests passed! STOAT is ready.{Colors.RESET}")
    else:
        print(f"\n{Colors.YELLOW}⚠️ Some tests failed. Check logs for details.{Colors.RESET}")

if __name__ == "__main__":
    main()