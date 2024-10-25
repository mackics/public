# Define the URL for the Google Chrome installer
$chromeInstallerUrl = "https://dl.google.com/chrome/install/latest/chrome_installer.exe"

# Define the path where the installer will be downloaded
$installerPath = "$env:TEMP\chrome_installer.exe"

# Download the installer
Write-Host "Downloading Google Chrome installer..."
Invoke-WebRequest -Uri $chromeInstallerUrl -OutFile $installerPath

# Run the installer silently
Write-Host "Installing Google Chrome..."
Start-Process -FilePath $installerPath -ArgumentList "/silent", "/install" -NoNewWindow -Wait

# Clean up the installer
Write-Host "Cleaning up..."
Remove-Item -Path $installerPath

# Define the bookmarks to add
$bookmarks = @(
    @{
        name = "Lascana"
        url = "https://www.lascana.com"
    },
    @{
        name = "Lascana"
        url = "https://www.lascana.com"
    }
)

# Define the path to the Chrome bookmarks file
$chromeBookmarksPath = "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Bookmarks"

# Wait for Chrome to create the bookmarks file if it doesn't exist yet
Start-Sleep -Seconds 10

# Read the existing bookmarks file
if (Test-Path $chromeBookmarksPath) {
    $bookmarksJson = Get-Content -Path $chromeBookmarksPath -Raw | ConvertFrom-Json
} else {
    # Create a new bookmarks structure if the file doesn't exist
    $bookmarksJson = @{
        roots = @{
            bookmark_bar = @{
                children = @()
                name = "Bookmarks bar"
                type = "folder"
            }
        }
        version = 1
    }
}

# Add the new bookmarks to the bookmarks bar
foreach ($bookmark in $bookmarks) {
    $bookmarksJson.roots.bookmark_bar.children += @{
        name = $bookmark.name
        type = "url"
        url = $bookmark.url
    }
}

# Save the updated bookmarks file
$bookmarksJson | ConvertTo-Json -Depth 10 | Set-Content -Path $chromeBookmarksPath

Write-Host "Google Chrome installation and bookmark addition completed."
