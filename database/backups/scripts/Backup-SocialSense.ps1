$BackupDir = "C:\Users\Andreas\Projects\SocialSense\database\backups"
$DbName = "SocialSense"
$UserName = "postgres" # Make sure this is your PostgreSQL username
$Date = Get-Date -Format "yyyyMMddHHmmss"
$BackupFile = Join-Path -Path $BackupDir -ChildPath "$DbName-$Date.backup"

# Ensure backup directory exists
if (!(Test-Path -Path $BackupDir)) {
    New-Item -ItemType Directory -Path $BackupDir | Out-Null
}

# Create the backup using the full path to pg_dump.exe
& "C:\Program Files\PostgreSQL\16\bin\pg_dump.exe" -h localhost -U $UserName -Fc -b -v -f $BackupFile $DbName

# Retention Policy: Keep latest 5 backups, delete the rest
$AllBackups = Get-ChildItem -Path $BackupDir -Filter "$DbName-*.backup"
if ($AllBackups.Count -gt 5) {
    $BackupsToDelete = $AllBackups | Sort-Object CreationTime -Descending | Select-Object -Skip 5
    $BackupsToDelete | ForEach-Object { Remove-Item -Path $_.FullName -Force }
}
