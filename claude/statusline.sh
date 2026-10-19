#!/bin/bash

# Claude Code status line: model · effort │ ctx % │ 5h % · wk % │ branch
# Groups are split by a dim │, parts inside a group by ·. A part or group with
# no data is left out. Wired up in ~/.claude/settings.json (statusLine).

input=$(cat)

# Unit-separator delimited: read collapses runs of tabs, which would shift
# fields along whenever one is empty.
IFS=$'\x1f' read -r model effort ctx five week dir < <(
  jq -r '[
    .model.display_name // "",
    .effort.level // "",
    .context_window.used_percentage // "",
    .rate_limits.five_hour.used_percentage // "",
    .rate_limits.seven_day.used_percentage // "",
    .workspace.current_dir // "."
  ] | map(tostring) | join("\u001f")' <<<"$input"
)

dim=$'\033[2m'
reset=$'\033[0m'
group_sep=" ${dim}│${reset} "
part_sep=" ${dim}·${reset} "

line=""
add_group() { line="${line:+$line$group_sep}$1"; }
color() { printf '\033[%sm%s\033[0m' "$1" "$2"; }
pct() { printf '%.0f%%' "$1"; }

# Model and its reasoning effort.
if [[ -n $model ]]; then
  group=$(color 36 "$model")
  [[ -n $effort ]] && group+="$part_sep$(color 36 "$effort")"
  add_group "$group"
fi

[[ -n $ctx ]] && add_group "$(color 33 "ctx $(pct "$ctx")")"

# Plan usage: 5-hour session and weekly limits.
usage=""
[[ -n $five ]] && usage=$(color 35 "5h $(pct "$five")")
[[ -n $week ]] && usage="${usage:+$usage$part_sep}$(color 35 "wk $(pct "$week")")"
[[ -n $usage ]] && add_group "$usage"

branch=$(git --no-optional-locks -C "$dir" symbolic-ref --short -q HEAD 2>/dev/null)
[[ -n $branch ]] && add_group "$(color 32 "$branch")"

printf '%s' "$line"
