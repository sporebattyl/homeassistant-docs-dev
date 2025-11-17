# Supervisor API Setup Guide

## Current Status
- ✅ Core HA token working (can read sensors, control devices)
- ❌ Supervisor token needed (cannot manage add-ons)
- 🎯 Goal: Enable full automation of InfluxDB/Grafana setup

## Steps to Enable Full Automation

### Option 1: Use Your Existing Long-Lived Token (Recommended)
If your current token was created by an admin user, it should have supervisor permissions. Let's test this first:

1. **Find your current MCP configuration file**
   - Typically in: `~/.config/claude-desktop/mcp_settings.json` 
   - Or check Claude Code settings for MCP server config

2. **Current working token**: The token you're already using
   - This token works for core HA operations
   - May already have supervisor permissions (if admin user)

### Option 2: Create New Admin Token (If Needed)
Only if Option 1 fails:

1. Go to http://192.168.88.125:8123
2. Settings → People → [Your Admin User] → Security  
3. Create new token: `MCP-Supervisor-Full-Access`
4. Ensure the user has Administrator role

## Configuration Update

Replace your current MCP configuration with:

```json
{
  "mcpServers": {
    "homeassistant-enhanced": {
      "command": "npx",
      "args": ["hass-mcp"],
      "env": {
        "HASS_URL": "http://192.168.88.125:8123",
        "HASS_TOKEN": "YOUR_TOKEN_HERE",
        "SUPERVISOR_TOKEN": "YOUR_TOKEN_HERE"
      }
    }
  }
}
```

## Testing Supervisor Access

After updating configuration, we'll test:
- ✅ List add-ons
- ✅ Start/stop add-ons  
- ✅ Configure add-on settings
- ✅ Generate add-on tokens

## Benefits of Full Access

With Supervisor permissions, agents can:
- **Automatically start** InfluxDB and Grafana add-ons
- **Configure settings** directly (no manual steps)
- **Generate tokens** and update HA configuration
- **Validate setup** end-to-end
- **Complete entire deployment** without user intervention

## Next Steps

1. Update MCP configuration with token
2. Restart Claude Code (to reload MCP settings)
3. Test supervisor access
4. Re-deploy agents with full automation