#! /bin/bash
# Create a simple log function
function log() {
    echo "$(date +"%Y-%m-%d %H:%M:%S") | $1"
}

log "Retrieve personal access token from pat.txt file"
PAT=$(cat pat.txt)

log "Checking connection to api.github.com..."
curl -sSf \
    -H "Authorization: Bearer $PAT" \
    -H "Accept: application/vnd.github+json" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    https://api.github.com/ > /dev/null && log "GitHub API available"

# exit program on failed connection
# $? is the exit code of the previous run
exit_code=$?
if [ $exit_code != 0 ]; then 
    log "GitHub API not available (curl returned code $exit_code)"
    exit $exit_code
fi

log "Removing temporary repo list file."
unlink repos.txt

log "Retrieving gh repo api pages"
linkheader=$(
    curl -sL --head --retry 5 \
    -H "Authorization: Bearer $PAT" \
    -H "Accept: application/vnd.github+json" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    "https://api.github.com/user/repos?affiliation=owner" | grep link
)

# regex to extract
re="(?<=page\=)[0-9]+(?=>; rel\=\"last\")"

# get the number of pages to extract from
num_pages=$(echo $linkheader | grep -Po "$re")

log "$num_pages pages available."

# Retrieve repos from each page
for i in $(seq 1 $num_pages); do
    apiurl="https://api.github.com/user/repos?page=$i&affiliation=owner"
    log "Retrieving repo names from $apiurl"
    resp=$(
        curl -sL --retry 5 \
        -H "Authorization: Bearer $PAT" \
        -H "Accept: application/vnd.github+json" \
        -H "X-GitHub-Api-Version: 2022-11-28" \
        "$apiurl"
    )
    echo $resp | jq -r '.[] | "\(.full_name)"' >> repos.txt
done

# function to update a repo that already exists on the drive
function update_repo() {
    log "Updating repo $1"
    cur=$PWD
    cd $1
    git fetch
    git reset --hard @{u}
    git clean -dfx
    cd $cur
}

# function to clone a repo that does not yet exist on the drive
function clone_repo() {
    log "Cloning repo $1"
    git clone "https://$PAT@github.com/$1" "$1"
}

# Actually perform the mirror
log "Mirroring GitHub..."
while read repo; do
    if [ -d "$repo" ]; then
        update_repo "$repo"
    else
        clone_repo "$repo"
    fi
done < repos.txt

exit 0
