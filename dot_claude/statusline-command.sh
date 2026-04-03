#!/usr/bin/env bash
# Claude Code status line script

input=$(cat)

# --- Parse all fields in a single jq call ---
mapfile -t f < <(echo "$input" | jq -r '
  .workspace.current_dir,
  .model.display_name,
  (.session_name // ""),
  (.context_window.used_percentage // 0 | floor | tostring),
  (.context_window.context_window_size // 0 | tostring),
  (.context_window.current_usage.cache_read_input_tokens // 0 | tostring),
  (.context_window.total_output_tokens // 0 | tostring),
  (.rate_limits.five_hour.used_percentage // -1 | if . == -1 then "" else (floor | tostring) end),
  (.rate_limits.five_hour.resets_at // -1 | if . == -1 then "" else tostring end),
  (.rate_limits.seven_day.used_percentage // -1 | if . == -1 then "" else (floor | tostring) end),
  (.rate_limits.seven_day.resets_at // -1 | if . == -1 then "" else tostring end)
')
current_dir="${f[0]}"
model_name="${f[1]}"
session_name="${f[2]}"
used_pct="${f[3]}"
tokens_max="${f[4]}"
cache_read="${f[5]}"
tokens_out="${f[6]}"
five_h="${f[7]}"
five_h_resets="${f[8]}"
seven_d="${f[9]}"
seven_d_resets="${f[10]}"

# --- Session tracking (elapsed time + compression detection) ---
session_file="${TMPDIR:-/tmp}/claude-status-${PPID}"
compressed=false
now=$(date +%s)
if [[ -f "$session_file" ]]; then
  read -r start_time prev_pct was_compressed < "$session_file"
  # Compression: percentage drops >10 points between updates
  if [[ "$was_compressed" == "true" ]]; then
    compressed=true
  elif [[ -n "$prev_pct" ]] && (( prev_pct - used_pct > 10 )); then
    compressed=true
  fi
else
  start_time=$now
fi
echo "$start_time $used_pct $compressed" > "$session_file"

# Elapsed time (only show after 1 minute)
elapsed=$(( now - start_time ))
elapsed_display=''
if (( elapsed >= 60 )); then
  eh=$(( elapsed / 3600 ))
  em=$(( (elapsed % 3600) / 60 ))
  if (( eh > 0 )); then
    elapsed_display="${eh}h${em}m"
  else
    elapsed_display="${em}m"
  fi
fi

# --- Smart number formatting (500 → "500", 45k, 1.2M) ---
fmt() {
  local n=$1
  if (( n >= 1000000 )); then
    local tenths=$(( n / 100000 ))
    local whole=$(( tenths / 10 ))
    local frac=$(( tenths % 10 ))
    if (( frac == 0 )); then
      echo "${whole}M"
    else
      echo "${whole}.${frac}M"
    fi
  elif (( n >= 1000 )); then
    echo "$(( n / 1000 ))k"
  else
    echo "$n"
  fi
}

# --- Git info ---
git_info=''
git_branch=$(git -C "$current_dir" -c gc.auto=0 branch --show-current 2>/dev/null)
if [[ -n "$git_branch" ]]; then
  git_info="  󰘬 $git_branch"

  # Worktree indicator
  git_dir=$(git -C "$current_dir" rev-parse --git-dir 2>/dev/null)
  git_common_dir=$(git -C "$current_dir" rev-parse --git-common-dir 2>/dev/null)
  if [[ -n "$git_dir" && "$git_dir" != "$git_common_dir" ]]; then
    git_info="$git_info ⎇ $(basename "$git_dir")"
  fi

  # Ahead/behind remote
  if git -C "$current_dir" rev-parse --abbrev-ref '@{upstream}' &>/dev/null; then
    ahead=$(git -C "$current_dir" rev-list --count '@{upstream}..HEAD' 2>/dev/null)
    behind=$(git -C "$current_dir" rev-list --count 'HEAD..@{upstream}' 2>/dev/null)
    ahead=${ahead:-0}; behind=${behind:-0}
    if (( ahead > 0 || behind > 0 )); then
      git_info="$git_info ↑${ahead}↓${behind}"
    fi
  fi

  # Dirty indicator
  git_status=$(git -C "$current_dir" -c gc.auto=0 status --porcelain 2>/dev/null)
  if [[ -n "$git_status" ]]; then
    git_info="$git_info ✦"
  fi
fi

# --- Session name ---
session_info=''
[[ -n "$session_name" ]] && session_info=" │ $session_name"

# --- ANSI colors ---
reset=$'\033[0m'
dim=$'\033[2m'
yellow=$'\033[33m'
red=$'\033[31m'

# --- Context usage color ---
if (( used_pct >= 75 )); then
  ctx_color=$red
elif (( used_pct >= 50 )); then
  ctx_color=$yellow
else
  ctx_color=$dim
fi

# --- Half-block bar (5% resolution) ---
half_pos=$(( used_pct * 20 / 100 ))
bar=''
for i in $(seq 1 10); do
  pos=$(( i * 2 ))
  if (( pos <= half_pos )); then
    bar="${bar}█"
  elif (( pos - 1 <= half_pos )); then
    bar="${bar}▌"
  else
    bar="${bar}░"
  fi
done

# --- Token display ---
effective_used=$(( used_pct * tokens_max / 100 ))
used_fmt=$(fmt $effective_used)
max_fmt=$(fmt $tokens_max)
cache_fmt=$(fmt $cache_read)
out_fmt=$(fmt $tokens_out)

# --- Compression indicator ---
compress_icon=''
[[ "$compressed" == "true" ]] && compress_icon=" ${dim}↯ compressed${reset}"

# --- Rate limit helper ---
fmt_rate() {
  local pct=$1 resets=$2 icon=$3 label=$4
  local color
  if (( pct >= 75 )); then color=$red
  elif (( pct >= 50 )); then color=$yellow
  else color=$dim; fi

  local out="${color}${icon}${label} ${pct}%"
  if [[ -n "$resets" ]]; then
    local rem=$(( resets - now ))
    if (( rem > 0 )); then
      local rd=$(( rem / 86400 )) rh=$(( (rem % 86400) / 3600 )) rm=$(( (rem % 3600) / 60 ))
      if (( rd > 0 && rh > 0 )); then
        out="${out} ${rd}d${rh}h"
      elif (( rd > 0 )); then
        out="${out} ${rd}d"
      elif (( rh > 0 )); then
        out="${out} ${rh}h${rm}m"
      else
        out="${out} ${rm}m"
      fi
      local rst
      rst=$(TZ=Asia/Kolkata date -r "$resets" '+%H:%M' 2>/dev/null)
      [[ -n "$rst" ]] && out="${out} ↻${rst}"
    fi
  fi
  echo "${out}${reset}"
}

rate_info=''
[[ -n "$five_h" ]] && rate_info="  $(fmt_rate "$five_h" "$five_h_resets" "⏱ " "5h")"
[[ -n "$seven_d" ]] && rate_info="${rate_info}  $(fmt_rate "$seven_d" "$seven_d_resets" "⏳" "7d")"

# --- Elapsed display (dim, right side of line 1) ---
elapsed_info=''
[[ -n "$elapsed_display" ]] && elapsed_info="  ${dim}${elapsed_display}${reset}"

# --- Output ---
# Line 1: repo, session, git, model, elapsed
# Line 2: context bar, tokens, compression, rate limits
printf " 󰉋 %s%s%s  ✨ %s%s\n %s%s%s %s%s%%%s  %s / %s  󰑐 %s  󰈔 %s%s%s" \
  "$(basename "$current_dir")" "$session_info" "$git_info" "$model_name" "$elapsed_info" \
  "$ctx_color" "$bar" "$reset" "$ctx_color" "$used_pct" "$reset" \
  "$used_fmt" "$max_fmt" "$cache_fmt" "$out_fmt" "$compress_icon" "$rate_info"
