# Pfad zu den Schriftarten auf dem lokalen Computer
$localFontsPath = "C:\Windows\Fonts"
# Pfad zum NAS
$nasFontsPath = "\\nas\pfad\zu\den\schriften"

# Teil 1: Kopieren Sie neue Schriftarten vom lokalen Computer auf das NAS
$localFonts = Get-ChildItem -Path $localFontsPath -Include *.ttf, *.otf
foreach ($font in $localFonts)
{
    if (!(Test-Path -Path "$nasFontsPath\$($font.Name)"))
    {
        Copy-Item $font.FullName -Destination $nasFontsPath
    }
}

# Teil 2: Installieren Sie alle neuen Schriftarten vom NAS auf dem lokalen Computer
$nasFonts = Get-ChildItem -Path $nasFontsPath -Include *.ttf, *.otf -Recurse
foreach ($font in $nasFonts)
{
    if (!(Test-Path -Path "$localFontsPath\$($font.Name)"))
    {
        Copy-Item $font.FullName -Destination $localFontsPath -Force

        $fontRegistryPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts"
        $fontName = [System.IO.Path]::GetFileNameWithoutExtension($font.Name) + " (TrueType)"
        Set-ItemProperty -Path $fontRegistryPath -Name $fontName -Value $font.Name
    }
}
