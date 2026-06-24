#!/bin/bash
# ensure-op.sh
# Guarantees T_Cheesy is always an operator, even after container restarts.
# Matches the ops.json format (JSON array) used by this server.
# Called automatically from start.sh before the server jar launches.

USERNAME="${1:-T_Cheesy}"
SERVER_DIR="$(dirname "$0")"
OPS_FILE="$SERVER_DIR/ops.json"
UUID_CACHE="$SERVER_DIR/usercache.json"

if [ ! -f "$OPS_FILE" ]; then
  echo "[]" > "$OPS_FILE"
fi

if grep -q "\"name\": \"$USERNAME\"" "$OPS_FILE" 2>/dev/null; then
  echo "$USERNAME is already in ops.json"
  exit 0
fi

UUID=""
if [ -f "$UUID_CACHE" ]; then
  UUID=$(grep -B1 "\"name\": \"$USERNAME\"" "$UUID_CACHE" | grep -oE '[0-9a-f-]{36}' | head -n1)
fi

if [ -z "$UUID" ]; then
  UUID=$(python3 -c "import uuid; print(uuid.uuid3(uuid.NAMESPACE_DNS, 'OfflinePlayer:$USERNAME'))" 2>/dev/null)
fi

python3 - "$OPS_FILE" "$UUID" "$USERNAME" <<'PYEOF'
import json, sys
ops_file, uuid_str, username = sys.argv[1], sys.argv[2], sys.argv[3]
try:
    with open(ops_file) as f:
        ops = json.load(f)
except Exception:
    ops = []

if not any(o.get("name") == username for o in ops):
    ops.append({
        "uuid": uuid_str,
        "name": username,
        "level": 4,
        "bypassesPlayerLimit": False
    })

with open(ops_file, "w") as f:
    json.dump(ops, f, indent=2)

print(f"Added {username} to ops.json (uuid: {uuid_str})")
PYEOF
