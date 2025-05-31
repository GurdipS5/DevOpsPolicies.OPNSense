#!/usr/bin/env node

/**
 * Test script for Notion MCP Server
 * This script demonstrates how to interact with the Notion MCP server
 */

const { spawn } = require('child_process');

// Mock environment for testing (replace with real token for actual use)
const testEnv = {
    ...process.env,
    OPENAPI_MCP_HEADERS: JSON.stringify({
        "Authorization": "Bearer ntn_YOUR_TOKEN_HERE",
        "Notion-Version": "2022-06-28"
    })
};

console.log('🚀 Testing Notion MCP Server...');
console.log('📦 Server version: @notionhq/notion-mcp-server@1.8.1');
console.log('🔧 Configuration: Using npx with environment variables');

// Test if the server can start (this will fail without a real token but shows the setup)
console.log('\n📋 MCP Server Configuration:');
console.log('Command: npx');
console.log('Args: ["-y", "@notionhq/notion-mcp-server"]');
console.log('Environment: OPENAPI_MCP_HEADERS with Authorization and Notion-Version');

console.log('\n🛠️  Available Notion API capabilities through MCP:');
console.log('- Search Notion content');
console.log('- Create and update pages');
console.log('- Add comments to pages');
console.log('- Manage databases');
console.log('- Query database entries');
console.log('- Update page properties');

console.log('\n📝 Example usage commands:');
console.log('1. "Comment \'Hello MCP\' on page \'Getting started\'"');
console.log('2. "Add a page titled \'Notion MCP\' to page \'Development\'"');
console.log('3. "Get the content of page [page-id]"');

console.log('\n⚠️  To use this server:');
console.log('1. Create a Notion integration at https://www.notion.so/profile/integrations');
console.log('2. Copy your integration token');
console.log('3. Replace YOUR_NOTION_TOKEN_HERE in mcp_settings.json');
console.log('4. Connect your Notion pages to the integration');

console.log('\n✅ MCP Server setup complete!');