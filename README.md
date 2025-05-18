# Bitbucket Unreviewed PRs Waybar Module

This project provides a custom Waybar module that displays the current number of unreviewed pull requests (PRs) from Bitbucket repositories. It fetches PR data from Bitbucket's API and formats it for display in Waybar, helping you keep track of pending code reviews directly from your desktop bar.

## Features

- Fetches pull requests from multiple Bitbucket projects and repositories.
- Shows the total count of unreviewed PRs.
- Displays a tooltip with PR titles and authors for quick overview.
- Uses Bitbucket API with token-based authentication.
- Configurable via environment variables.

## Requirements

- [Waybar](https://github.com/Alexays/Waybar) (for the module integration)
- `bash` shell
- `jq` command-line JSON processor
- `curl` for HTTP requests

## Setup

1. Clone this repository or copy the `fetchPrs.sh` and `openBitbucket.sh` scripts to your system.

2. Create a configuration file with your Bitbucket credentials and repository list, for example:

   ```bash
   # ~/.config/bitbucket-prs/.env
   export BITBUCKET_URL="https://bitbucket.example.com"
   export BITBUCKET_USERNAME="your_username"
   export BITBUCKET_TOKEN="your_api_token"
   export BITBUCKET_PROJECT_REPOS=("key1:slug1" "key2:slug2")
   ```
3. Make sure the scripts are executable:

   ```bash
   chmod +x fetchPrs.sh
   chmod +x openBitbucket.sh
   ```

4. Configure your Waybar module to call this script and parse its JSON output. Example Waybar config snippet:

   ```json
    "custom/prs": {
        "format": "{icon} {text}",
        "return-type": "json",
        "max-length": 40,
        "interval" : 300,
        "format-icons": {
            "default": ""
        },
        "escape": true,
        "on-click": "path/to/openBitbucket.sh 2> /dev/null",
        "exec": "path/to/fetchPrs.sh 2> /dev/null" 
    }

   ```

## Usage

Run the script manually to test:

```bash
./fetchPrs.sh
```

It will output JSON with the total number of unreviewed PRs and a tooltip containing PR titles and authors.

## Notes

- The script uses `jq` to parse and format JSON data.
- The environment variables must be set or sourced before running the script.
- Adjust the `BITBUCKET_PROJECT_REPOS` array to include all your monitored projects and repositories.

## License

This project is provided as-is under the MIT License.
