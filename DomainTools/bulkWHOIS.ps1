$baseURL = "http://api.domaintools.com/v1/"
$URISuffix = "/whois/"
$Auth = "YOUR_API_KEY_HERE" #Make sure you replace with your valid API key from DomainTools
$wc = new-object System.net.WebClient
$requests = get-content .\URIs.txt
$count = 0
$file = "C:\temp\bulkwhois_$((Get-Date).ToString('MM-dd-yyyy')).csv"
$fileExists = Test-Path $file
$whoisArray = @()

if ($fileExists -eq 'True')
{
del $file
Write-Host "Previous export list deleted"
}

write-host "Script Executing!`n"

#Loop to through various IP addresses for WHOIS lookup

foreach ($request in $requests)
{
$count = $count + 1
$fullCmdString = "$baseURL"+"$request"+"$URISuffix"+"$Auth"

#Support from DomainTools said we had to limit the number of requests, so built-in 1 minute pauses per 120 requests.
if($count -eq 120)
{
Start-Sleep -s 60

$count = 0
$configJson = $wc.DownloadString($fullCmdString)

}

else
{
$configJson = $wc.DownloadString($fullCmdString)
}

#Taking the JSON response and converting the values into an array to be ingested into a PowerShell.
$registrant = (ConvertFrom-Json $configJson).response.registrant
$organization = @((ConvertFrom-Json $configJson).response.whois.record.split("`n") | where {$_ -like "*Organization*"})
$domainName = @((ConvertFrom-Json $configJson).response.whois.record.split("`n") | where {$_ -like "*Domain Name*"})
$netName = @((ConvertFrom-Json $configJson).response.whois.record.split("`n") | where {$_ -like "*NetName*"})
$regDate = @((ConvertFrom-Json $configJson).response.whois.record.split("`n") | where {$_ -like "*RegDate*"})
$updated = @((ConvertFrom-Json $configJson).response.whois.record.split("`n") | where {$_ -like "Updated*"})
$custName = (ConvertFrom-Json $configJson).response.whois.record.split("`n") | where {$_ -like "*CustName*"}
$netRange = @(ConvertFrom-Json $configJson).response.whois.record.split("`n") | where {$_ -like "*NetRange*"}
$cidr = @(ConvertFrom-Json $configJson).response.whois.record.split("`n") | where {$_ -like "*CIDR*"}
$nameServer = @(ConvertFrom-Json $configJson).response.whois.record.split("`n") | where {$_ -like "*Name Server*"}
$abuseEmail = (ConvertFrom-Json $configJson).response.whois.record.split("`n") | where {$_ -like "*AbuseEmail*"}
$techEmail = (ConvertFrom-Json $configJson).response.whois.record.split("`n") | where {$_ -like "*TechEmail*"}

[System.Collections.ArrayList]$orgList=$organization
[System.Collections.ArrayList]$dnList=$DomainName
[System.Collections.ArrayList]$rdList=$regDate
[System.Collections.ArrayList]$upList=$updated
[String[]]$cidrList=$cidr
[String[]]$nrList=$netRange
[System.Collections.ArrayList]$nsList=$nameServer
[String[]]$aeList=$abuseEmail
[String[]]$teList=$techEmail
[System.Collections.ArrayList]$nnList=$netName


#Used for reporting in CSV format (though you could certainly output to host if desired).
$objWHOIS = New-Object System.Object
$objWHOIS | Add-Member -type NoteProperty -name URI -value $request
$objWHOIS | Add-Member -type NoteProperty -name Registrant -value $registrant
$objWHOIS | Add-Member -type NoteProperty -name Organization -value $orgList
$objWHOIS | Add-Member -type NoteProperty -name domainName -value $dnList
$objWHOIS | Add-Member -type NoteProperty -name netName -value $nnList
$objWHOIS | Add-Member -type NoteProperty -name CustName -value $custName
$objWHOIS | Add-Member -type NoteProperty -name RegDate -value $rdList
$objWHOIS | Add-Member -type NoteProperty -name Updated -value $upList
$objWHOIS | Add-Member -type NoteProperty -name NetRange -value $nrList
$objWHOIS | Add-Member -type NoteProperty -name CIDR -value $cidrList
$objWHOIS | Add-Member -type NoteProperty -name nameServer -value $nsList
$objWHOIS | Add-Member -type NoteProperty -name abuseEmail -value $aeList
$objWHOIS | Add-Member -type NoteProperty -name techEmail -value $teList

$whoisArray += $objWHOIS

}

#Do some sorting - not sure if this step is required due to object names likely being unique anyway
$whoisArray = $whoisArray | sort-object -Property  {$_.name } -Unique

#Write CSV in UTF8 in case of foreign names
$whoisArray  | Export-Csv -Encoding UTF8 -LiteralPath $file -NoTypeInformation 

Write-Host "`nDone"

