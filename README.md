# ClickUp Shell Scripts

Useful shell scripts for interacting with ClickUp tasks from the command line.

## Scripts Overview

### 1. `clickup-task-info.sh`
**Purpose**: Automatically extracts ClickUp task information from your current Git branch name and displays task details.

**Use Case**: When working on a feature branch named with a ClickUp task ID (e.g., `feature/CU-869aupbu6`), this script will:
- Extract the task ID from the branch name
- Fetch task details from the ClickUp API
- Display formatted task information including title, status, and assignees

**Usage**:
```bash
./clickup-task-info.sh
```

**Output Example**:
```bash
ClickUp Task: CU-869AUPBU6
📋 Title: Implement User Authentication
📊 Status: in progress
👤 Assignees: john.doe, jane.smith
```

### 2. `clickup-subtasks.sh`
**Purpose**: Fetches all subtasks for a given ClickUp parent task and outputs them in GitHub-friendly markdown format.

**Use Case**: Perfect for creating task checklists in GitHub issues, pull requests, or documentation. Generates markdown with:
- Checkboxes indicating completion status
- Clickable links to each subtask
- Properly formatted task IDs and names

**Usage**:
```bash
./clickup-subtasks.sh CU-869aupbu6
# OR
./clickup-subtasks.sh 869aupbu6
```

**Output Example**:
```markdown
- [x] [CU-abc123 Set up database schema](https://app.clickup.com/t/abc123)
- [ ] [CU-def456 Implement authentication](https://app.clickup.com/t/def456)
- [ ] [CU-ghi789 Create user dashboard](https://app.clickup.com/t/ghi789)
```

## Prerequisites

### Required Dependencies
- **jq**: JSON processor (often pre-installed)
  ```bash
  # Ubuntu/Debian
  sudo apt install jq
  
  # macOS
  brew install jq
  
  # CentOS/RHEL/Fedora
  sudo dnf install jq
  ```

- **curl**
- **git**

## Setup Instructions

### 1. Get Your ClickUp API Token

1. **Log in to ClickUp**: Go to [app.clickup.com](https://app.clickup.com)
2. **Access Settings**: Click your avatar in the top right corner → **Settings**
3. **Navigate to Apps**: Click **Apps** in the left sidebar
4. **Generate Token**: 
   - Scroll down to **API Token** section
   - Click **Generate**
   - Copy the generated token (it looks like `pk_123456789_ABC...`)

⚠️ **Important**: Keep this token secure and never commit it to version control!

### 2. Configure Environment Variables

Create a `.env` file in the same directory as the scripts:

```bash
echo 'CLICKUP_API_TOKEN="pk_your_actual_token_here"' > .env
```

### 3. Make Scripts Executable

```bash
chmod +x clickup-task-info.sh clickup-subtasks.sh
```

### 4. Add Scripts to Your PATH (Optional but Recommended)

To use these scripts from anywhere in your system (assumes you have cloned the repo into your home directory):

#### Option A: Symlink to a directory already in PATH
```bash
# Create symlinks in /usr/local/bin (requires sudo)
sudo ln -s $HOME/clickUpScripts/clickup-task-info.sh /usr/local/bin/clickup-task-info
sudo ln -s $HOME/clickUpScripts/clickup-subtasks.sh /usr/local/bin/clickup-subtasks
```

#### Option B: Add the scripts directory to your PATH
Add this line to your shell configuration file (`~/.bashrc`, `~/.zshrc`, etc.):

```bash
# For zsh users (~/.zshrc)
export PATH="$PATH:$HOME/clickUpScripts"
```

Then reload your shell

## Troubleshooting

### Common Issues

1. **"Missing CLICKUP_API_TOKEN environment variable"**
   - Ensure your `.env` file exists in the same directory as the scripts
   - Verify the token is properly formatted in the `.env` file

2. **"No ClickUp task ID found in branch"**
   - Branch name must contain a ClickUp task ID in format `CU-xxxxxxx`
   - Examples: `feature/CU-123abc-new-feature`, `bugfix/cu-456def-fix-login`

3. **"jq: command not found"**
   - Install jq using your package manager (see Prerequisites section)

4. **API errors (401, 403)**
   - Verify your API token is correct and hasn't expired
   - Check that you have access to the specified task/workspace

5. **"No subtasks found or invalid task ID"**
   - Verify the task ID exists and you have access to it
   - Ensure the parent task actually has subtasks

## Contributing

Feel free to submit issues or pull requests to improve these scripts!

## License

MIT License - feel free to use and modify as needed.
