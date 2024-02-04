# GitHub mirror

Basic bash script to keep a copy of all your GitHub repos.

## Functionality

The [`githubmirror.sh`](githubmirror.sh) script does the following:

1. 🔏 Read your [Personal Access Token](https://github.com/settings/tokens?type=beta) from a file called `pat.txt` (which you have to make and write to the root directory).
2. 🔗 Connect to the GitHub API to find all the repos of which you are an owner (even private ones!).
3. 🗃️ If the repo does not exist locally, clone it into the folder `<github_username>/<repo_name>`. If it does exist, go to the local clone and `git reset` it to the origin (i.e., ensure the exact same state as github).
4. 📜 Write nice logs along the way.


## Running the script
To run the script while keeping logs, I recommend the following:

```sh
# run gitmirror, pipe stdout and stderr to log file
./gitmirror.sh >> "logs/$(date +'%Y%m%d').log" 2>&1
```
