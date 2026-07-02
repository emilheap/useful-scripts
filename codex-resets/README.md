# Codex Reset Credits

Displays your available banked Codex reset credits (does not reset) and shows how long remains before each credit expires.

Make the script executable:

    chmod +x codex-resets.sh

Run it:

    ./codex-resets.sh

Or execute it with `sh`:

    sh codex-resets.sh

Use another authentication file:

    ./codex-resets.sh /path/to/auth.json

## Expiration Colors

- Under 7 days: red
- From 7 to under 14 days: yellow
- 14 days or more: green

## Example Output


    Local banked Codex resets
    available_count=2

    available_credits:
    status      granted_at                         expires_at
    available   2026-06-28T14:25:10.123456Z        2026-07-28T14:25:10.123456Z (in 26d 14h 15m)
    available   2026-06-30T08:40:00.654321Z        2026-07-06T08:40:00.654321Z (in 4d 8h 30m)
