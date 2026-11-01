with open('D:/REA/Roblox/Grow a Garden/nodehub_garden_auto_kg.lua', 'r', encoding='utf-8', errors='ignore') as f:
    text = f.read()

import re

lines = text.split('\n')
print(f'Total lines: {len(lines)}')
print(f'Total size: {len(text)} bytes')

# Find modules/tabs
mods = re.findall(r'--\s*\[\[\s*MODULE:\s*([^\]]+)\s*\]\]', text)
print(f'Modules in file ({len(mods)}):')
for m in mods[:20]:
    print(' ', m.strip())

# Find UI window name
title_m = re.findall(r'title\s*=\s*"([^"]+)"', text, re.IGNORECASE)
print('Titles:', list(dict.fromkeys(title_m))[:10])

