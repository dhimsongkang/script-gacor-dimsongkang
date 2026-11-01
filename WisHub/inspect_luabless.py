with open('D:/REA/Roblox/WisHub/wishub_payload_79216.lua', 'r', encoding='utf-8', errors='ignore') as f:
    text = f.read()

import re
# Find any URLs or domain names
urls = re.findall(r'https?://[^\s"\'\)]+', text)
print('URLs found in loader:', set(urls))

# Find references to global functions / services
services = re.findall(r'GetService\s*\(\s*["\']([^"\']+)["\']', text)
print('Services accessed:', set(services))

# Find any strings containing api or wishub
wishub_refs = re.findall(r'["\'][^"\']*(?:wishub|key|auth|api|token|loader)[^"\']*["\']', text, re.IGNORECASE)
print('Key/WisHub string literals:', set(wishub_refs[:20]))

