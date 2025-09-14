# Symfony + React Development Environment

A complete development setup with:
- PHP 8.3
- Node.js 22
- Symfony 7.3
- React 18

## Getting Started with Codespaces

1. Click "Code" → "Codespaces" → "Create codespace on main"
2. Wait for the container to build and setup script to complete
3. The setup will automatically install all dependencies

## Development Commands

To run the two separate environments (Symfony and React) simultaneously, open two terminal panes in Codespaces, and run one of the following commands in each pane:
### Symfony Backend
```bash
# Start Symfony development server
symfony server:start
```

### React Frontend
```bash
# Start React development server with Vite
npm run dev
```

## Other Symfony commands that may be useful
```bash
# Run Symfony commands
symfony console make:controller
symfony console doctrine:migrations:migrate
```

## Project Structure
```
├── .devcontainer/         # Codespaces configuration
├── assets/                # React source files
│   ├── index.html         # Index page for the React app
│   ├── app.jsx            # Main React component
│   └── app.css            # Styles
├── src/                   # Application source files
│   ├── Framework          # Symfony code
│   ├── Application        # Application logic
│   ├── Infrastucture      # Infrastructure code
│   ├── Domain             # Domain models and code
├── public/                # Public web files
├── var/                   # Symfony cache and logs
├── composer.json          # PHP dependencies
├── package.json           # Node.js dependencies
├── payload.json           # The content that should be served by the Symfony API
└── vite.config.js         # Vite configuration
```
