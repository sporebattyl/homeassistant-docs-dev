# 🔐 Secure Secrets Management

This configuration uses a secure secrets management system to keep all credentials out of chat and version control.

## Setup Instructions

### 1. Configure Your Secrets

Edit the secrets file with your actual credentials:
```bash
nano state/secrets.env
```

Replace the placeholder values:
- `YOUR_LONG_LIVED_ACCESS_TOKEN_HERE` → Your HA long-lived access token
- `YOUR_USERNAME_HERE` → Your Home Assistant username
- `YOUR_PASSWORD_HERE` → Your Home Assistant password

### 2. Authentication Modes

Choose your preferred authentication method by setting `AUTH_MODE`:

**Option A: API Token (Recommended)**
```bash
export AUTH_MODE="TOKEN"
export HA_TOKEN="your_actual_token_here"
```

**Option B: Username/Password**
```bash
export AUTH_MODE="USERPASS"
export HA_USER="your_username"
export HA_PASS="your_password"
```

**Option C: Browser Session Only**
```bash
export AUTH_MODE="SESSION_ONLY"
# No credentials needed - uses existing browser session
```

### 3. Usage in Scripts

All scripts and tools automatically load secrets:
```bash
# Load secrets before any HA operations
source ./state/load_secrets.sh

# Now use environment variables safely
curl -H "Authorization: Bearer $HA_TOKEN" "$HA_BASE_URL/api/"
```

## Security Features

- **File Permissions**: 600 (owner read/write only)
- **Git Ignored**: Never committed to version control
- **No Chat Exposure**: Credentials never appear in Claude conversations
- **Validation**: Automatic checks for required variables
- **Rotation Support**: Built-in credential rotation tracking

## File Structure

```
state/
├── secrets.env         # Your actual credentials (600 permissions)
├── load_secrets.sh     # Loader script (700 permissions)
├── ha_token           # Alternative token file (if used)
└── ROTATED_*          # Rotation incident logs
```

## Security Best Practices

1. **Never share state/secrets.env**
2. **Rotate credentials regularly**
3. **Use API tokens over passwords when possible**
4. **Monitor for credential exposure**
5. **Keep backup credentials in secure password manager**

## Troubleshooting

**"Secrets not loaded" error:**
```bash
# Check file exists and has correct permissions
ls -la state/secrets.env

# Test the loader
./state/load_secrets.sh
```

**"Invalid AUTH_MODE" error:**
- Ensure AUTH_MODE is set to: TOKEN, USERPASS, or SESSION_ONLY
- Check for typos in secrets.env

**API authentication failures:**
- Verify HA_TOKEN is current and valid
- Check HA_BASE_URL is correct
- Ensure Home Assistant is accessible# Updated: Fri Nov 14 14:11:01 CST 2025
# Clean rsync deployment achieved - Fri Nov 14 14:42:01 CST 2025
# Final cleanup test - Fri Nov 14 14:42:38 CST 2025
# Test operational-only deployment - Fri Nov 14 14:49:08 CST 2025
# Clean deployment test - Fri Nov 14 14:53:26 CST 2025
# Legacy cleanup complete - Fri Nov 14 17:28:02 CST 2025
# Rsync CIFS fix applied - Fri Nov 14 17:30:29 CST 2025
# Security improvements applied - Fri Nov 14 20:49:00 CST 2025
# Token updated in secrets.env - Fri Nov 14 20:49:34 CST 2025
# Final test - Fri Nov 14 20:50:00 CST 2025
# Preview script test - Fri Nov 14 20:54:53 CST 2025
# Test auto-reload detection - Fri Nov 14 21:06:06 CST 2025
