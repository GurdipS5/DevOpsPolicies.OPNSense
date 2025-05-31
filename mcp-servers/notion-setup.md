# Notion MCP Server Setup

This directory contains the setup for the Notion MCP server integration.

## Configuration

The MCP server has been configured in `../mcp_settings.json` with the server name `github.com/makenotion/notion-mcp-server`.

## Required Setup Steps

### 1. Create Notion Integration
1. Go to https://www.notion.so/profile/integrations
2. Create a new **internal** integration
3. Copy the integration token (starts with `ntn_`)

### 2. Connect Pages to Integration
1. Visit the Notion pages/databases you want to access
2. Click the 3 dots menu
3. Select "Connect to integration"
4. Choose your integration

### 3. Update Token in Configuration
Replace `YOUR_NOTION_TOKEN_HERE` in `../mcp_settings.json` with your actual Notion integration token.

## Security Considerations

- The integration token provides access to connected Notion content
- Consider creating a read-only integration if you only need to read data
- Only connect the specific pages/databases you need to access

## Usage

Once configured, the MCP server provides tools to:
- Search Notion content
- Create and update pages
- Add comments
- Manage databases
- And more Notion API functionality

## Testing

You can test the server by using MCP tools to interact with your Notion workspace.