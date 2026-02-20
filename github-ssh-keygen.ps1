# GitHub SSH Key Generator
# Generates an ED25519 SSH key pair and configures it for GitHub

$EMAIL = Read-Host "Enter your GitHub email"

if ([string]::IsNullOrWhiteSpace($EMAIL)) {
    Write-Host "Error: Email cannot be empty." -ForegroundColor Red
    exit 1
}

$KeyFile = "$env:USERPROFILE\.ssh\id_ed25519_github"
$SshDir = "$env:USERPROFILE\.ssh"

# Create .ssh directory if it doesn't exist
if (-not (Test-Path $SshDir)) {
    New-Item -ItemType Directory -Path $SshDir -Force | Out-Null
}

# Generate SSH key
Write-Host "Generating SSH key..."
ssh-keygen -t ed25519 -C $EMAIL -f $KeyFile -N '""'

# Start ssh-agent service and add key
Get-Service ssh-agent | Set-Service -StartupType Automatic
Start-Service ssh-agent
ssh-add $KeyFile

# Configure SSH to use this key for GitHub
$ConfigFile = "$SshDir\config"
$GithubEntry = @"

Host github.com
    HostName github.com
    User git
    IdentityFile $KeyFile
    IdentitiesOnly yes
"@

if (Test-Path $ConfigFile) {
    $content = Get-Content $ConfigFile -Raw
    if ($content -notmatch "Host github\.com") {
        Add-Content -Path $ConfigFile -Value $GithubEntry
        Write-Host "SSH config updated."
    }
} else {
    Set-Content -Path $ConfigFile -Value $GithubEntry.TrimStart()
    Write-Host "SSH config created."
}

Write-Host ""
Write-Host "=========================================" -ForegroundColor Green
Write-Host "  SSH key generated successfully!" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Public key (copy this to GitHub -> Settings -> SSH Keys):"
Write-Host ""
Get-Content "${KeyFile}.pub"
Write-Host ""

# Copy to clipboard
Get-Content "${KeyFile}.pub" | Set-Clipboard
Write-Host "Public key copied to clipboard!" -ForegroundColor Yellow
Write-Host ""
Write-Host "GitHub SSH keys page: https://github.com/settings/keys"
