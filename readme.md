# GitHub mirror

![GitHub License](https://img.shields.io/github/license/vankesteren/githubmirror) ![GitHub file size in bytes](https://img.shields.io/github/size/vankesteren/githubmirror/githubmirror.sh)

A small, legible bash script to keep a copy of all your GitHub repos. The `githubmirror.sh` script does the following:

- 🔏 Read your [Personal Access Token](https://github.com/settings/tokens?type=beta) from a local file.
- 🔗 Connect to the GitHub API to find all the repos of which you are an owner (even private ones!).
- 🗃️ Clone repos into the folder `<github_username>/<repo_name>`. If it already exists, `git reset` it to ensure the exact same state as GitHub.
- 📜 Write nice logs along the way.

## Installation

To set up githubmirror on your own linux system:

1. Ensure you have a recent version of the dependencies installed: [`curl`](https://curl.se), [`jq`](https://jqlang.github.io/jq/), and [`git`](https://git-scm.com/).
2. Clone this repository
3. Request your [Personal Access Token](https://github.com/settings/tokens?type=beta) and store it in a plain file called `pat.txt`.
3. `chmod +x ./githubmirror.sh`
4. Set up a weekly recurring task (via `cron` or via your OS's task scheduler) to run the script. To run the script while keeping logs, I recommend the following:
   ```bash
   # run gitmirror, pipe stdout and stderr to log file
   ./githubmirror.sh >> "logs/$(date +'%Y%m%d').log" 2>&1
   ```
