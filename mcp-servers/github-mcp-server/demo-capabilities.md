# GitHub MCP Server Capabilities Demo

This document demonstrates the capabilities of the GitHub MCP Server once it's properly configured and running.

## Prerequisites for Demo

1. ✅ Server configuration added to `mcp_settings.json`
2. ⚠️ Docker installation required (or build from source)
3. ⚠️ GitHub Personal Access Token needed
4. ⚠️ MCP client connection required

## Tool Demonstrations

### 1. User Information Tool

**Tool**: `get_me`
**Purpose**: Get details of the authenticated user
**Usage**: No parameters required

```json
{
  "tool": "get_me",
  "parameters": {}
}
```

**Expected Response**: User profile information including login, name, email, etc.

### 2. Repository Search Tool

**Tool**: `search_repositories`
**Purpose**: Search for GitHub repositories
**Usage**: 

```json
{
  "tool": "search_repositories",
  "parameters": {
    "query": "mcp server",
    "sort": "stars",
    "order": "desc",
    "perPage": 5
  }
}
```

**Expected Response**: List of repositories matching the search criteria

### 3. File Content Access Tool

**Tool**: `get_file_contents`
**Purpose**: Get contents of a file from a repository
**Usage**:

```json
{
  "tool": "get_file_contents",
  "parameters": {
    "owner": "github",
    "repo": "github-mcp-server",
    "path": "README.md"
  }
}
```

**Expected Response**: File content with metadata

### 4. Issue Management Tool

**Tool**: `list_issues`
**Purpose**: List issues in a repository
**Usage**:

```json
{
  "tool": "list_issues",
  "parameters": {
    "owner": "github",
    "repo": "github-mcp-server",
    "state": "open",
    "perPage": 5
  }
}
```

**Expected Response**: List of open issues with details

### 5. User Search Tool

**Tool**: `search_users`
**Purpose**: Search for GitHub users
**Usage**:

```json
{
  "tool": "search_users",
  "parameters": {
    "q": "github",
    "perPage": 3
  }
}
```

**Expected Response**: List of users matching the search criteria

## Resource Access Demonstrations

### 1. Repository Content Resource

**Resource URI**: `repo://github/github-mcp-server/contents/README.md`
**Purpose**: Access repository content via resource URI
**Expected Response**: File content and metadata

### 2. Branch-Specific Content Resource

**Resource URI**: `repo://github/github-mcp-server/refs/heads/main/contents/package.json`
**Purpose**: Access content from a specific branch
**Expected Response**: File content from the specified branch

## Advanced Capabilities

### Pull Request Operations
- Create pull requests
- Review and merge pull requests
- Add comments and reviews
- Update pull request branches

### Security Features
- List code scanning alerts
- Access secret scanning alerts
- Security vulnerability management

### Repository Management
- Create and fork repositories
- Manage branches and commits
- File operations (create, update, delete)
- Push multiple files in single commits

## Next Steps

To actually use these tools:

1. **Install Docker** or **build from source** following the setup instructions
2. **Get a GitHub Personal Access Token** from https://github.com/settings/personal-access-tokens/new
3. **Update the configuration** in `mcp_settings.json` with your token
4. **Connect your MCP client** to the server
5. **Run the test script** to verify functionality

## Error Handling

Common issues and solutions:
- **Authentication errors**: Verify your GitHub token has the required permissions
- **Rate limiting**: GitHub API has rate limits; the server handles these gracefully
- **Network issues**: Ensure stable internet connection for API calls
- **Permission errors**: Some operations require specific repository permissions

## Security Considerations

- Use tokens with minimal required permissions
- Regularly rotate your GitHub Personal Access Tokens
- Monitor token usage and revoke if compromised
- Be cautious with write operations in production repositories