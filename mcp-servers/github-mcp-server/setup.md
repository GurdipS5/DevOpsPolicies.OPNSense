# GitHub MCP Server Setup

This directory contains the setup for the GitHub MCP Server from https://github.com/github/github-mcp-server.

## Configuration

The server has been added to `mcp_settings.json` with the name `github.com/github/github-mcp-server`.

## Prerequisites

**Option 1: Docker (Recommended)**
1. **Docker**: Install Docker Desktop for Windows from https://www.docker.com/products/docker-desktop/
2. **GitHub Personal Access Token**: You need to create a GitHub Personal Access Token

**Option 2: Build from Source**
1. **Go**: Install Go from https://golang.org/dl/
2. **Git**: Ensure Git is installed
3. **GitHub Personal Access Token**: You need to create a GitHub Personal Access Token

## Current Status

⚠️ **Docker is not currently installed on this system.** You'll need to install Docker Desktop for Windows to use the current configuration, or follow the "Build from Source" instructions below.

## Creating a GitHub Personal Access Token

1. Go to https://github.com/settings/personal-access-tokens/new
2. Select the permissions you want to grant (the MCP server can use many GitHub APIs)
3. Generate the token and copy it

## Setup Steps

### Option 1: Using Docker (Current Configuration)

1. Install Docker Desktop for Windows
2. Replace `YOUR_GITHUB_TOKEN_HERE` in `mcp_settings.json` with your actual GitHub Personal Access Token
3. Ensure Docker is running
4. The server will use Docker to run the GitHub MCP server container

### Option 2: Build from Source

1. Install Go and Git if not already installed
2. Clone the repository:
   ```cmd
   git clone https://github.com/github/github-mcp-server.git
   cd github-mcp-server
   ```
3. Build the binary:
   ```cmd
   go build -o github-mcp-server.exe ./cmd/github-mcp-server
   ```
4. Update `mcp_settings.json` to use the built binary instead of Docker:
   ```json
   "github.com/github/github-mcp-server": {
     "command": "path/to/github-mcp-server.exe",
     "args": ["stdio"],
     "env": {
       "GITHUB_PERSONAL_ACCESS_TOKEN": "YOUR_GITHUB_TOKEN_HERE"
     }
   }
   ```

## Available Toolsets

The server supports the following toolsets (all enabled by default):
- `repos` - Repository-related tools (file operations, branches, commits)
- `issues` - Issue-related tools (create, read, update, comment)
- `users` - Anything relating to GitHub Users
- `pull_requests` - Pull request operations (create, merge, review)
- `code_security` - Code scanning alerts and security features
- `experiments` - Experimental features (not considered stable)

## Configuration Options

You can customize the server by adding environment variables to the `env` section in `mcp_settings.json`:

- `GITHUB_TOOLSETS`: Comma-separated list of toolsets to enable (e.g., "repos,issues,pull_requests")
- `GITHUB_DYNAMIC_TOOLSETS`: Set to "1" to enable dynamic toolset discovery
- `GITHUB_HOST`: For GitHub Enterprise Server (e.g., "https://your-ghes-domain.com")

## Example Tools Available

- **Users**: `get_me`, `search_users`
- **Issues**: `get_issue`, `create_issue`, `list_issues`, `add_issue_comment`
- **Pull Requests**: `get_pull_request`, `create_pull_request`, `merge_pull_request`
- **Repositories**: `create_or_update_file`, `list_branches`, `search_repositories`
- **Code Security**: `list_code_scanning_alerts`, `list_secret_scanning_alerts`

## Resources

The server also provides resources for accessing repository content:
- Repository content at specific paths
- Content for specific branches, commits, tags, or pull requests