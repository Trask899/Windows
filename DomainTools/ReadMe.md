# Bulk WHOIS Lookup using DomainTools API

***Background:*** 

This is a script used to look up a long list of external IP addresses that belonged to my organization in preperation for external vulnerability scanning. We have paid subscriptions to DomainTools and needed a way gather a set of information quickly. At the time this script was written, they didn't have an option to do IP ranges or CIDRs, so it was a long list of individual IPs in URIs.txt that is ingested into the script and parsed through the API calls in a loop.


***Usage:***

Modify URIs.txt with your list of individual IP addresses.

You must add your API key into bulkWHOIS.ps1 from DomainTools for this to work.

From PowerShell simply run:

```PowerShell
.\bulkWHOIS.ps1
```

Example output looks like this:

[! Example] (ExampleOutput/Example.png)