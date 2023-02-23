### DENGET UPGRADER SCRIPT ###

param (
   [string]$curver,
   [string]$dgpath
)

try {
Write-Quiet "Downloading the latest release from GitHub..."
$oldProgressPreference = $ProgressPreference
$global:ProgressPreference = 'SilentlyContinue'
Invoke-WebRequest -Uri https://github.com/mutr0p/congenial-fishstick/releases/latest/download/denget.zip -OutFile "$dgpath\denget.zip" 
$global:ProgressPreference = $oldProgressPreference

Write-Quiet "Extracting files..."
$oldProgressPreference = $ProgressPreference
$global:ProgressPreference = 'SilentlyContinue'
Expand-Archive -Path "$dgpath\denget.zip" -DestinationPath $dgpath -Force
$global:ProgressPreference = $oldProgressPreference

Get-ChildItem $dgpath\denget | Move-Item -Destination $dgpath -Force

Write-Quiet "Updating buckets..."
& denget update

Write-Quiet "Cleaning up..."
Remove-Item "$dgpath\denget.zip" -Force
Remove-Item "$dgpath\denget" -Force
}
catch {
   Write-Host "Error: " -f r -n
   Write-Host "upgrading has failed. Here's an error message:"
   Write-Host $_
   return -1
}

### ADDITIONAL UPGRADE STEPS ###

$curverArr = $curver.Split(".")
$major = $curverArr[0]
$minor = $curverArr[1]
$patch = $curverArr[2]

## <VERSION> - <CHANGE>

return 0