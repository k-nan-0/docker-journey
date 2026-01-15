param (
    [Parameter(Mandatory=$true)]
    [string]$ProjectPath,

    [Parameter(Mandatory=$true)]
    [string]$OutputFolderName
)

# Define the full output path relative to the current directory or a specific base path
# Here, it creates the output folder in the current execution directory
$OutputPath = Join-Path (Get-Location) $OutputFolderName

Write-Host "Starting build for project: $ProjectPath"
Write-Host "Output path: $OutputPath"

# Run the dotnet build command
# The -p argument is used to specify the project file, and -o for the output directory
try {
    dotnet build $ProjectPath -o $OutputPath
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Build completed successfully."
    } else {
        Write-Error "dotnet build failed with exit code: $LASTEXITCODE"
    }
} catch {
    Write-Error "An error occurred during the build process: $_"
}
