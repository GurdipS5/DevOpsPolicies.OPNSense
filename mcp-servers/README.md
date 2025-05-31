# MCP Servers Directory

This directory contains MCP (Model Context Protocol) server configurations and setup files.

## Installed Servers

### Notion MCP Server
- **Package**: `@notionhq/notion-mcp-server@1.8.1`
- **Server Name**: `github.com/makenotion/notion-mcp-server`
- **Status**: ✅ Installed and configured
- **Configuration**: See `../mcp_settings.json`

### GitHub MCP Server
- **Repository**: `https://github.com/github/github-mcp-server`
- **Server Name**: `github.com/github/github-mcp-server`
- **Status**: ⚠️ Configured (requires Docker or build from source)
- **Configuration**: See `../mcp_settings.json` and `github-mcp-server/setup.md`

## Files

- [`notion-setup.md`](./notion-setup.md) - Detailed setup instructions for Notion integration
- [`test-notion-mcp.js`](./test-notion-mcp.js) - Test script demonstrating server capabilities
- [`github-mcp-server/setup.md`](./github-mcp-server/setup.md) - GitHub MCP server setup instructions
- [`github-mcp-server/test-github-mcp.js`](./github-mcp-server/test-github-mcp.js) - GitHub MCP server test script
- [`README.md`](./README.md) - This file

## Quick Start

1. **Install Dependencies**: Already completed ✅
   ```bash
   npm install -g @notionhq/notion-mcp-server
   ```

2. **Configure Notion Integration**:
   - Visit https://www.notion.so/profile/integrations
   - Create a new internal integration
   - Copy the integration token

3. **Update Configuration**:
   - Edit `../mcp_settings.json`
   - Replace `YOUR_NOTION_TOKEN_HERE` with your actual token

4. **Connect Notion Pages**:
   - Visit your Notion pages
   - Click "..." → "Connect to integration"
   - Select your integration

5. **Test the Setup**:
   ```bash
   node test-notion-mcp.js
   ```

## Available Capabilities

### Notion MCP Server
The Notion MCP server provides tools for:
- 🔍 Searching Notion content
- 📝 Creating and updating pages
- 💬 Adding comments to pages
- 🗃️ Managing databases
- 📊 Querying database entries
- ⚙️ Updating page properties

### GitHub MCP Server
The GitHub MCP server provides tools for:
- 👤 User management and authentication
- 📁 Repository operations (create, fork, file management)
- 🐛 Issue tracking (create, update, comment, search)
- 🔀 Pull request management (create, merge, review)
- 🔍 Code and repository searching
- 🛡️ Security scanning (code and secret alerts)
- 📊 Notifications and activity tracking
- 🌿 Branch and commit operations

## Security Notes

- Use read-only integration tokens when possible
- Only connect necessary pages/databases to your integration
- Keep your integration token secure and never commit it to version control

## Usage Examples

Once configured, you can use natural language commands like:
- "Comment 'Hello MCP' on page 'Getting started'"
- "Add a page titled 'Notion MCP' to page 'Development'"
- "Get the content of page [page-id]"

The MCP server will automatically translate these into appropriate Notion API calls.