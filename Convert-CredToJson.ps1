$un=$Args[0].Substring(1)
$pw=$Args[1].Substring(1)
$vpnName=$Args[2].Substring(1)
$Args[3]=$Args[3].Substring(1)
$server = $Args[3].replace("@",".")
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
Install-Module -Force -Name VPNCredentialsHelper

Add-Type -AssemblyName PresentationCore,PresentationFramework
$ButtonType = [System.Windows.MessageBoxButton]::YesNoCancel
$MessageIcon = [System.Windows.MessageBoxImage]::Error

$MessageTitle = "Confirm Deletion"


$vpn = Get-VpnConnection -Name $vpnName;

if($vpn.ConnectionStatus -eq "Connected"){
  rasdial $vpnName /DISCONNECT;
}
Add-VpnConnection -Name $vpnName -ServerAddress $server -TunnelType "Ikev2" -RememberCredential
Set-VpnConnectionUsernamePassword -connectionname $vpnName -username $un -password $pw -domain ''
$cmd = $env:WINDIR + "\System32\rasdial.exe"
$expression = "$cmd $vpnname"
Invoke-Expression -Command $expression 


$MessageBody=$expression
