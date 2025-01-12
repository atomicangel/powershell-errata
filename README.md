# powershell-errata
Random Powershell Scripts I put together. Some are bits of a bigger project, some are standalone that filled a need.

A lot of what is in this repo are things that I put together to help me do things without my needing to do them manually.

Battery Test: Exactly what you think it is. Does not stress test any components, but gives you an idea of how long the battery can last in minutes.
The date is appended to the file as well to show the sleep periods in between usage. Can be an indicator that sleep mode is still draining the battery.

CSV: I made this as an easy way to generate a comma separated value file I could easily load into Excel/copy into inventory.
It runs a PowerShell command on the remote system to pull it's Serial Number that's reported from the BIOS. So far that has been reliable.
It then prompts the user for the inventory tag and writes both to the CSV file.

File-Copy: Made this as a way to copy files dynamically by checking it's last write time. This prevents copying files that haven't changed since the last copy.
Made this since I sometimes need files to be available on the go without internet/LAN access. I only needed this for a very small set of files but it can be expanded to handle more complex cases.

General-Cleanup: Made this since I was finding a set of computers that were being modified in a manner inconsistent with policy.
This allowed me to clean up the system in an automatic fashion. It deletes all user profiles beginning with numbers but not letters. This exempted supervisory positions while covering all the other users in this scenario.
I also made exemptions for admin accounts to ensure those were not deleted as they were likely to be the accounts that were logged in during use of this script.
This then deletes the folders that cover local copies of Group Policy. Not sure if this is still needed in modern systems but older builds of Windows 10 needed this.
Finally it removes all extra WiFi profiles that aren't supposed to be in the system since the system I was involved in used GPO to apply WiFi policies.

Show-ADObjectOwner: Made this to solve an issue with AD Computers not finishing an imaging cycle. It pulls the Owner for the AD Object requested. In our case it was for computers specifically.
Backstory: We would run our SCCM deployment and if the computer object was owned by any user except a specific internal one it would fail to join the Domain. This has something to do with a change in Microsoft policy circa November 2023.
Not sure if there is an alternative to fixing it but for us the solution is removing the object and creating a new one, then moving it back to it's former OU. I have a basic script that covers this I'll include either in this repo or elsewhere.

USB-Reset: Had a separate issue with a specific device model that needs USB NICs to have an ethernet connection. The NICs wouldn't fully initialize once the deployment rebooted into the image.
We ended up needing a way to try and automate resetting the devices but the closest we came to this was resetting the whole hub. This ended up not working for our purposes but I'm including it because this is the result of that effort and it might be useful for something else.

I have other scripts I'll be adding as I have time, but I wanted to get a basic set into this repo to get started.

