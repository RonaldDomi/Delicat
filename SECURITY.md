# Security Configuration

## API Keys Management

### Setup
1. Copy `assets/Keys.example.json` to `assets/Keys.json`
2. Replace placeholder values with your actual Unsplash API credentials
3. Don't commit `assets/Keys.json` to version control

### File Structure
```
assets/
├── Keys.json          # Your actual API keys (gitignored)
└── Keys.example.json  # Template with placeholders (tracked)
```

### Unsplash API Keys
- **Access Key**: Used for public API calls
- **Secret Key**: Used for authenticated operations

Get your keys from: https://unsplash.com/developers

