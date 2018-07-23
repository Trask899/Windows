$ComputerNames = get-content .\computers.txt
$WinLogonArr = @()
$file = "C:\temp\WinLogonScrape\autoLogon_$((Get-Date).ToString('MM-dd-yyyy')).csv"
$fileExists = Test-Path $file

if ($fileExists -eq 'True')
{
del $file
Write-Host "Previous export list deleted"
}

foreach ($ComputerName in $ComputerNames){

$Hive = [Microsoft.Win32.RegistryHive]::LocalMachine
$KeyPath = 'SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\Winlogon'
$Pwd = 'DefaultPassword'
$Usr = 'DefaultUserName'
$Domain = 'DefaultDomainName'
$Enabled = 'AutoAdminLogon'


$reg = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey($Hive, $ComputerName)

$key = $reg.OpenSubKey($KeyPath)

$EnabledValue = $key.GetValue($Enabled)
$DomainValue = $key.GetValue($Domain)
$UsrValue = $key.GetValue($Usr)
$PwdValue = $key.GetValue($Pwd)

$compInfo = New-Object PSObject

$compInfo | Add-Member -type NoteProperty -name "Computer Name" -value $ComputerName
$compInfo | Add-Member -type NoteProperty -name "Enabled" -value $EnabledValue
$compInfo | Add-Member -type NoteProperty -name "Domain" -value $DomainValue
$compInfo | Add-Member -type NoteProperty -name "Username" -value $UsrValue
$compInfo | Add-Member -type NoteProperty -name "Password" -value $PwdValue

$WinLogonArr += $compInfo

}

#Write CSV in UTF8 in case of foreign names
$WinLogonArr  | Export-Csv -Encoding UTF8 -LiteralPath $file -NoTypeInformation 

Write-Host "Done"