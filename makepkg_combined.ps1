$basePath = "AutoIdentify_EE"
$tp2Name = "AutoIdentify"
$modPath = $basePath + "/" + $tp2Name 
$archive = $basePath + ".zip"
$exePath = "setup-" + $tp2Name + ".exe"
$folders = @(
'tra'
)

Remove-Item -LiteralPath $modPath -Force -Recurse

foreach($folder in $folders){
	Copy-Item -Path $folder -Destination ($modPath + "/" + $folder) -Recurse
	
}

& $PSScriptRoot/d_compactor.ps1 -dPath $modPath

Copy-Item -Path ("functions.tph") -Destination $modPath 
Copy-Item -Path ($tp2Name + ".tp2") -Destination $modPath 
Copy-Item -Path "../weidu.exe" -Destination ($basePath + "/" + $exePath)
Copy-Item -Path "Release Notes.md" -Destination ($basePath + "/Release Notes.md")
Copy-Item -Path "Discord Server.url" -Destination ($basePath + "/Discord Server.url")
#Remove-Item -LiteralPath ($testDir + $tp2Name) -Force -Recurse

#Copy-Item -Path $modPath -Destination $testDir -Recurse

#Remove-Item -LiteralPath $basePath -Force -Recurse


$7zipPath = "$env:ProgramFiles/7-Zip/7z.exe"

if (-not (Test-Path -Path $7zipPath -PathType Leaf)) {
	$7zipPath = "F:/Program Files/7-Zip/7z.exe"
}

Set-Alias Start-SevenZip $7zipPath

$Source = "./" + $basePath + "/*"
$Target = "./" + $archive

Start-SevenZip a -mx=9 $Target $Source

Remove-Item -LiteralPath $basePath -Force -Recurse
Get-FileHash $archive -Algorithm SHA256 > SHA256.txt

Copy-Item -Path $archive -Destination ("\\192.168.1.88\smbuser\Home\Installers\" + $archive)