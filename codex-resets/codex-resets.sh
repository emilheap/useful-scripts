#!/bin/sh

auth_file=${1:-${CODEX_HOME:-"$HOME/.codex"}/auth.json}
token=$(jq -er '.tokens.access_token | select(length > 0)' "$auth_file") || exit 1
account=$(jq -r '.tokens.account_id // empty' "$auth_file") || exit 1

response=$(
  {
    printf '%s\n' \
      'url = "https://chatgpt.com/backend-api/wham/rate-limit-reset-credits"' \
      'header = "Accept: application/json"'
    printf 'header = "Authorization: Bearer %s"\n' "$token"
    [ -z "$account" ] || printf 'header = "ChatGPT-Account-Id: %s"\n' "$account"
  } | curl -fsS -K -
) || exit 1

printf '%s\n' 'Local banked Codex resets'

printf '%s\n' "$response" | jq -r '
  def color($code; $text): "\u001b[\($code)m\($text)\u001b[0m";

  def duration($seconds):
    "\($seconds / 86400 | floor)d "
    + "\(($seconds % 86400) / 3600 | floor)h "
    + "\(($seconds % 3600) / 60 | floor)m";

  def expiry:
    . as $date
    | (($date | sub("\\.[0-9]+Z$"; "Z") | fromdateiso8601) - now | floor) as $left
    | if $left <= 0 then
        "\($date) (\(color(31; "expired " + duration(-$left))))"
      else
        (if $left < 604800 then 31
         elif $left < 1209600 then 33
         else 32 end) as $color
        | "\($date) (\(color($color; "in " + duration($left))))"
      end;

  "available_count=\(color(32; (.available_count // 0 | tostring)))",
  "",
  "available_credits:",
  (["status", "granted_at", "expires_at"] | @tsv),
  (.credits[]
    | select((.status // "available") == "available" or .status == "")
    | [
        (.status // "available"),
        (.granted_at // "-"),
        (.expires_at | expiry)
      ]
    | @tsv)
'

printf '\n%s\n' '------------------------------------------------------------------------------------------------------------------------------------------'
