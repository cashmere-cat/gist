New-Module -Name infra -ScriptBlock {

Function Script() {
    [Alias('run')]
    param (
        [string]$GitHubToken
    )

    $dependencies = @(
        "Microsoft.PowerShell",
        "Git.Git",
        "Oven-sh.Bun"
    )

    foreach ($dependency in $dependencies) {
        winget install --id $dependency --exact --silent --no-upgrade --source winget
    }

    if (-not $GitHubToken) {
        Write-Host "Error: GitHub Token is required."
        return
    }

    $RepoUrl = "https://github.com/cashmere-cat/infra.git"
    $RepoName = pwsh { Split-Path $args[0] -LeafBase } -args $RepoUrl
    $RepoPath = $RepoUrl.Substring(8)
    
    git clone "https://x-access-token:$GitHubToken@$RepoPath" $RepoName

    if (-not (Test-Path $RepoName)) {
        Write-Host "Failed to enter repository directory"
        return
    }

    Set-Location -Path $RepoName

    Write-Host "Running script with Bun..."
    bun run scripts/bootstrap/bootstrap.ts
}

Export-ModuleMember -Function 'Script' -Alias 'run'
}

# . { iwr -useb https://cashmere-cat.github.io/gist/bootstrap.ps1 } | iex; run -GitHubToken <token>