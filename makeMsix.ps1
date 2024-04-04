param(
	[string]$workingDirectory = $PSScriptRoot,
	[string]$version=1.0.0.0
) 
Write-Host 'Executing Powershell script makeMsix.ps1 with working directory set to: ' $workingDirectory
Set-Location $workingDirectory

[Reflection.Assembly]::LoadWithPartialName("System.Xml.Linq")
$path = $workingDirectory + "/dnGREP.ContextMenuPkg/AppxManifest.xml"
$doc = [System.Xml.Linq.XDocument]::Load($path)
$xName = [System.Xml.Linq.XName]"{http://schemas.microsoft.com/appx/manifest/foundation/windows10}Identity"
$doc.Root.Element($xName).Attribute("Version").Value = $version;
$doc.Save($path)

$makeappx = "C:\Program Files (x86)\Windows Kits\10\bin\10.0.22000.0\x64\makeappx.exe"
$packagePath = $workingDirectory + "/dnGREP.ContextMenuPkg"
$msixPath = $workingDirectory + "/dnGREP.msix"
$args = "pack /d `"$packagePath`" /p `"$msixPath`" /nv"
Start-Process -NoNewWindow -FilePath "$makeappx" -ArgumentList "$args"