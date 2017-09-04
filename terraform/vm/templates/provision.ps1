Import-Module NetSecurity

function Expand-ZIPFile($file, $destination)
{
  $shell = new-object -com shell.application
  $zip = $shell.NameSpace($file)
  foreach($item in $zip.items())
  {
    $shell.Namespace($destination).copyhere($item)
  }
}

write-host "`n  ## NODEJS INSTALLER ## `n"

### CONFIGURATION

# nodejs
$version = "8.4.0"
$url = "https://nodejs.org/dist/v$version/node-v$version-x64.msi"

# git
$git_version = "2.9.2"
$git_url = "https://github.com/git-for-windows/git/releases/download/v$git_version.windows.1/Git-$git_version-64-bit.exe"

$install_git = $TRUE

if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
   write-Warning "This setup needs admin permissions. Please run this file as admin."     
   break
}


### git install


    if (Get-Command git -errorAction SilentlyContinue) {
        $git_current_version = (git --version)
    }

    if ($git_current_version) {
        write-host "[GIT] $git_current_version detected. Proceeding ..."
    } else {
        $git_exe = "$PSScriptRoot\git-installer.exe"

        write-host "No git version dectected"

        $download_git = $TRUE
        
        if (Test-Path $git_exe) {
            $confirmation = read-host "Local git install file detected. Do you want to use it ? [Y/n]"
            if ($confirmation -eq "n") {
                $download_git = $FALSE
            }
        }

        if ($download_git) {
            write-host "downloading the git for windows installer"
        
            $start_time = Get-Date
            $wc = New-Object System.Net.WebClient
            $wc.DownloadFile($git_url, $git_exe)
            write-Output "git installer downloaded"
            write-Output "Time taken: $((Get-Date).Subtract($start_time).Seconds) second(s)"
        }
        
        write-host "proceeding with git install ..."
        $command = "$git_exe /SILENT"
        write-host "running $command"
        start-Process $command /SILENT -Wait
        write-host "git installation done"
    }

### download nodejs msi file
# warning : if a node.msi file is already present in the current folder, this script will simply use it
        
write-host "`n----------------------------"
write-host "  nodejs msi file retrieving  "
write-host "----------------------------`n"

$filename = "node.msi"
$node_msi = "$PSScriptRoot\$filename"

write-host "[NODE] downloading nodejs install"
write-host "url : $url"
$start_time = Get-Date
$wc = New-Object System.Net.WebClient
$wc.DownloadFile($url, $node_msi)
write-Output "$filename downloaded"
write-Output "Time taken: $((Get-Date).Subtract($start_time).Seconds) second(s)"

### nodejs install

write-host "`n----------------------------"
write-host " nodejs installation  "
write-host "----------------------------`n"

write-host "[NODE] running $node_msi"
Start-Process "msiexec" -ArgumentList "/qn /l* C:\node-log.txt /i $node_msi" -Wait

$oldPath=(Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH).Path
$newPath="%APPDATA%\npm;C:\Program Files\nodejs;" + $oldPath
Set-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH –Value $newPath

$env:Path = $newPath

write-host "`n----------------------------"
write-host "  fetch quake server          "
write-host "----------------------------`n"

$quake_server_path = "c:\quakeserver"
$quake_zip = "$PSScriptRoot\quake.zip"
$url = "https://github.com/hashicorp/terraform-quake-azure/archive/master.zip"
$wc.DownloadFile($url, $quake_zip)
Expand-ZIPFile -File $quake_zip -Destination "c:\"
Copy-Item -Path "c:\terraform-quake-azure-master\WebQuake\Server" -Destination $quake_server_path -Recurse

Start-Process "npm" -ArgumentList "install" -WorkingDirectory $quake_server_path -Wait

write-host "`n----------------------------"
write-host "  install service             "
write-host "----------------------------`n"
Start-Process "npm" -ArgumentList "run install-windows-service" -WorkingDirectory $quake_server_path -Wait
Start-Service -displayname "QuakeServer"
New-NetFirewallRule -DisplayName 'HTTP(S) Inbound QuakeServer' -Profile @('Domain', 'Private', 'Public') -Direction Inbound -Action Allow -Protocol TCP -LocalPort @('26000')

