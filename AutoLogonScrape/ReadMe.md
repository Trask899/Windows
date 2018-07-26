# AutoLogonScrape

***Background:***

Needed to write a quick script in order to pull registry values from remote servers that were utilizing Autologons and wanted to place the information inside a CSV file. Utilized .NET commands due to remote Windows management restrictions preventing PowerShell from natively reading the registry.

*Note: Run with user account that has local administrative privileges on target system(s).*

Pulls the following information from the registry: 
- Domain Name
- Username
- Password (in plaintext)
- Whether or not autologon is enabled



***Directions for use:***

Update computers.txt with list of Computer names or IP addresses for target computers

From PowerShell run: 
```PowerShell
.\AutoLogonScrape.ps1
```
