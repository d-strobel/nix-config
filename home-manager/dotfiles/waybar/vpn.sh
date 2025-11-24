# Get vpn interfaces
interfaces=$(ip a | grep -oP '^\d+: (wg[0-9]+|ppp[0-9]+):' | awk '{print $2}' | sed 's/://')

count=$(echo "$interfaces" | wc -l)
if [ "$count" -gt 1 ]; then
  # Output multiple VPNs
  printf '{"text": "%s", "class": "success"}\n' "$(echo "$interfaces" | paste -sd'+' -)"
elif [ "$count" -eq 1 ]; then
  # Output single VPN
  printf '{"text": "%s", "class": "success"}\n' "$interfaces"
fi
