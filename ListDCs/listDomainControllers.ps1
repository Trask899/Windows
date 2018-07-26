$domainNames = Get-Content .\domains.txt
$file = "C:\temp\allDCs_$((Get-Date).ToString('MM-dd-yyyy')).csv"
$fileExists = Test-Path $file

if ($fileExists -eq 'True')
{
del $file
Write-Host "Previous export list deleted"
'' | Select 'Name','IPv4Address','IPv6Address','Domain','OperatingSystem','OperatingSystemServicePack', 'LDAPPort','SSLPort','ComputerObjectDN','IsReadOnly' | Export-Csv $file -NoTypeInformation
}
else
{
'' | Select 'Name','IPv4Address','IPv6Address','Domain','OperatingSystem','OperatingSystemServicePack','SSLPort', 'LDAPPort','ComputerObjectDN','IsReadOnly' | Export-Csv $file -NoTypeInformation
}


foreach($domainName in $domainNames)
{

$allDCs = $domainName | %{ Get-ADDomainController -Filter * -Server $_ } | Select Name,IPv4Address,IPv6Address,Domain,OperatingSystem,OperatingSystemServicePack,LDAPPort,SSLPort,ComputerObjectDN,IsReadOnly

Write-Host "Creating exported list of Domain Controllers from $domainName"

$allDCs | Export-Csv $file -Append

}




Write-Host "Done"