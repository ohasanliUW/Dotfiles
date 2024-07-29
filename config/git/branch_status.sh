#!/bin/bash

# ANSI color codes
LIGHT_PURPLE='\033[1;35m'
BLUE='\033[0;34m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Devicons for custom icons (make sure your terminal supports Nerd Fonts)
MERGED_ICON=""     # Rocket icon for merged (Devicon code: \uf135)
NON_MERGED_ICON="-" # Cross mark for non-merged (Devicon code: \uf05e)

# Function to display time in a human-readable format
displaytime() {
    local T=$1
    local D=$((T / 60 / 60 / 24))
    local H=$((T / 60 / 60 % 24))
    local M=$((T / 60 % 60))
    local S=$((T % 60))
    (($D > 0)) && printf '%d days ' $D
    (($H > 0)) && printf '%d hours ' $H
    (($M > 0)) && printf '%d minutes ' $M
    (($D > 0 || $H > 0 || $M > 0)) && printf 'and '
    printf '%d seconds ago' $S
}

# Function to fetch merged branches
fetch_merged_branches() {
    gh pr list -s merged --json headRefName --jq '.[].headRefName'
}

parse_date() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS date command
        date -j -f "%Y-%m-%d %H:%M:%S %z" "$1" +"%s"
    else
        # GNU date command
        date -d "$1" +"%s"
    fi
}

# Main function to display branch status
branch_status() {
    main_branch=$(git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@')
    printf "%-10s %-10s ${LIGHT_PURPLE}%-10s${NC} ${BLUE}%-40s${NC} %-20s\n" 'Merged' 'Ahead' 'Behind' 'Branch' 'Last Commit'

    # Prefetch merged branches
    merged_branches=$(fetch_merged_branches)

    # Array to hold branch information
    branches_info=()

    # Iterate over local branches
    for branch in $(git for-each-ref --format='%(refname:short)' refs/heads/); do
        behind=$(git rev-list --count $branch..$main_branch)
        ahead=$(git rev-list --count $main_branch..$branch)
        last_commit=$(git log -1 --format=%ci $branch)
        last_commit_delta=$(parse_date "$last_commit")
        now=$(date +%s)
        delta=$((now - last_commit_delta))
        time_ago=$(displaytime $delta)

        # Determine if the branch is merged
        if echo "$merged_branches" | grep -qw "$branch"; then
            merged="$MERGED_ICON"
        else
            merged="$NON_MERGED_ICON"
        fi

        # Add branch info to the array
        branches_info+=("$last_commit_delta|$merged|$ahead|$behind|$branch|$time_ago")
    done

    # Sort the array by last commit date (latest at the top)
    IFS=$'\n' sorted_branches=($(sort -t '|' -k1,1nr <<<"${branches_info[*]}"))
    unset IFS

    # Print sorted branches
    for branch_info in "${sorted_branches[@]}"; do
        IFS='|' read -r last_commit_delta merged ahead behind branch time_ago <<<"$branch_info"
        if [ "$merged" == "$MERGED_ICON" ]; then
            w="%-12s"
        else
            w="%-10s"
        fi
        printf "$w %-10s ${LIGHT_PURPLE}%-10s${NC} ${BLUE}%-40s${NC} %-20s\n" "$merged" $ahead $behind $branch "$time_ago"
    done
}

# Run the branch status function
branch_status
