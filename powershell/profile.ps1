
# install some modules

Import-Module $env:ChocolateyToolsLocation'\poshgit\dahlbyk-posh-git-9bda399\src\posh-git.psd1'

# Import the Chocolatey Profile that contains the necessary code to enable tab-completions to function for `choco`.
# See https://ch0.co/tab-completion for details.
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}

$CmdPromptUser = [Security.Principal.WindowsIdentity]::GetCurrent();

# Test for Admin / Elevated
$IsAdmin = (New-Object Security.Principal.WindowsPrincipal ([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
    
$Date = Get-Date -Format 'dddd, hh:mm:ss tt'

$profile = $PSCommandPath

$env:Path = $env:Path -replace ";;", ";"  # :)

Set-Alias touch New-Item
Set-Alias vscode codium

# load all scripts from ScriptsDir
$ScriptsDir = "$HOME\Documents\WindowsPowerShell\Scripts"
foreach ($xp in (Get-ChildItem $ScriptsDir)){
    $sPath = Join-Path $ScriptsDir $xp
    if($xp -like "*.ps1"){ . $sPath}
}

# handling ctrl+backspace for vscode:
if ($env:TERM_PROGRAM -eq "vscode") {
  Set-PSReadLineKeyHandler -Chord 'Ctrl+w' -Function BackwardKillWord
}

$GitPromptSettings.DefaultPromptPath = ""
$GitPromptSettings.DefaultPromptSuffix = ""


# print greetings
Write-Host "`nHello, " -NoNewline
Write-Host "$($CmdPromptUser.Name.split("\")[1])" -BackgroundColor DarkBlue -ForegroundColor White -NoNewline
Write-Host ". This is your Powershell." -NoNewline
Write-Host
Write-Host "`tToday is " -NoNewline
Write-Host "$Date" -BackgroundColor DarkMagenta

<#
if($IsAdmin){
    Write-Host "`tThis PS is running with elevated status." -ForegroundColor Green
    cd "C:\Users\$($env:USERNAME)"
}
#>


function prompt {

    $CmdPromptCurrentFolder = Split-Path -Path $pwd -Leaf
    
    $hostversion="v$($Host.Version.Major).$($Host.Version.Minor)"
    $hostname = $host.Name
    $windowTitle = "PS"

    # check whether PS is running on its own or in ISE
    if($hostname -eq "ConsoleHost")
    {
        $windowTitle = "$windowTitle $hostversion"
    } else {
        $windowTitle = "$windowTitle ISE $hostversion"
    }
    
    if ($IsAdmin)
    {
        $host.ui.RawUI.WindowTitle = "$windowTitle [sudo] - $pwd"
    }
    Else
    {
        $host.ui.RawUI.WindowTitle = "$windowTitle - $pwd"
    }

    #Calculate execution time of last cmd and convert to milliseconds, seconds or minutes
    $LastCommand = Get-History -Count 1
    if ($lastCommand) { $RunTime = ($lastCommand.EndExecutionTime - $lastCommand.StartExecutionTime).TotalSeconds }

    if ($RunTime -ge 60) {
        $ts = [timespan]::fromseconds($RunTime)
        $min, $sec = ($ts.ToString("mm\:ss")).Split(":")
        $ElapsedTime = -join ($min, " min ", $sec, " s")
    }
    else {
        $ElapsedTime = [math]::Round(($RunTime), 2)
        $ElapsedTime = -join (($ElapsedTime.ToString()), " s")
    }

    #Decorate the CMD Prompt
    
    $prompt = " "
    $prompt += Write-Host "[$elapsedTime] " -NoNewline -ForegroundColor Green
    $prompt += Write-Host (($pwd -split '\\')[-3..-1] -join '\') -ForegroundColor White -NoNewline
    
    $prompt += & $GitPromptScriptBlock
    # Write-Host " $date " -ForegroundColor White
    
    $prompt += Write-Host " >" -NoNewline
    if($IsAdmin){
         $prompt += Write-host " " -NoNewline
         $prompt += Write-host 'sudo' -ForegroundColor White -NoNewline
    }
    
    $prompt
}
