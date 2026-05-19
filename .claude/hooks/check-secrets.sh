#!/bin/bash
# Scans staged and unpushed content for common secret patterns before git push.
# Returns blocking JSON if secrets found; exits 0 silently if clean.

diff_content=$(
  git diff --cached 2>/dev/null
  git log "@{u}..HEAD" --patch 2>/dev/null
)

if [ -z "$diff_content" ]; then
  exit 0
fi

found=""

# AWS access key
if echo "$diff_content" | grep -qE '^\+.*AKIA[0-9A-Z]{16}'; then
  found="AWS access key (AKIA...)"
fi

# Private keys
if [ -z "$found" ] && echo "$diff_content" | grep -qiE '^\+.*-----BEGIN (RSA |EC |DSA |OPENSSH )?PRIVATE KEY'; then
  found="private key"
fi

# OpenAI / Anthropic API keys
if [ -z "$found" ] && echo "$diff_content" | grep -qE '^\+.*sk-(ant-api03-|ant-)?[a-zA-Z0-9_-]{20,}'; then
  found="OpenAI/Anthropic API key (sk-...)"
fi

# Hardcoded secrets in code assignments (skip template placeholders $VAR / <KEY>)
if [ -z "$found" ] && echo "$diff_content" | grep -qiE '^\+.*(api_key|apikey|api-key|secret_key|auth_token|access_token|password|passwd)\s*[:=]\s*"[^"$<{]{8,}"'; then
  found="hardcoded secret in code"
fi

# .env-style KEY=value (not $VAR, not <placeholder>)
if [ -z "$found" ] && echo "$diff_content" | grep -qiE '^\+[A-Z_]*(API_KEY|SECRET|AUTH_TOKEN|ACCESS_TOKEN|PASSWORD|PASSWD|DB_PASS|DATABASE_URL)=[^$<({"[:space:]][^[:space:]]{5,}'; then
  found=".env-style secret assignment"
fi

if [ -n "$found" ]; then
  printf '{"continue": false, "stopReason": "BLOCKED: Possible %s detected in push content. Review with: git diff --cached && git log @{u}..HEAD -p"}\n' "$found"
fi
