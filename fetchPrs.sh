#!/bin/bash

source ~/.config/waybar/prs/.env

fetch_prs_json() {
  local project_key=$1
  local repository_slug=$2
  curl --silent --insecure --request GET \
    --url "${BITBUCKET_URL}/rest/api/latest/projects/${project_key}/repos/${repository_slug}/pull-requests?username.1=${BITBUCKET_USERNAME}&approved.1=false&role.1=REVIEWER" \
    -H "Authorization: Bearer ${BITBUCKET_TOKEN}" \
    -H "Accept: application/json;charset=UTF-8"
}


concatenate_all_prs() {
  local all_values="[]"
  for pair in "${BITBUCKET_PROJECT_REPOS[@]}"; do
    local project_key="${pair%%:*}"
    local repository_slug="${pair#*:}"
    local response
    response=$(fetch_prs_json "$project_key" "$repository_slug")
    local values
    values=$(echo "$response" | jq '.values')
    all_values=$(jq -s 'add' <(echo "$all_values") <(echo "$values"))
  done
  echo "$all_values"
}

prs_json=$(concatenate_all_prs)

get_titles_and_users() {
  local titles_and_users
  titles_and_users=$(echo "$prs_json" |  jq 'map({title: .title, user: .author.user.displayName})')
  echo "$titles_and_users"
}

titles_and_users=$(get_titles_and_users)

get_values_size() {
  echo "$response" | jq 'length'
}

summarize_unreviewed_prs() {
  local total
  total=$(echo "$prs_json" | jq 'length')
  echo "PRs: $total"
}

format_titles_and_users() {
  local json_input=$1
  echo "$json_input" | jq -r '
    map(
      "[" + .user + "] " + 
      (.title | if length > 30 then (.[:30] + "...") else . end)
    ) | join("\r")
  '
}
tooltip=$(format_titles_and_users "$titles_and_users")
text=$(summarize_unreviewed_prs)
echo "{\"text\": \"$text\", \"alt\": \"alt\", \"tooltip\": \"${tooltip}\"}"
