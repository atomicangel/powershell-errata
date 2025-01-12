<#
This is used as a way to clean up systems with too many profiles.
It also forces Group Policy to clean up any files in the System32 folder.
It also handles removing any unapproved Wi-Fi profiles.
#>
Write-Output "Pulling all student profiles to be removed..."
$profiles = Get-WMIObject -class Win32_UserProfile | Where {((!$_.Special) -and ($_.LocalPath -match '[0-9]') -and ($_.LocalPath -ne "C:\Users\admin_user1") -and ($_.LocalPath -ne "C:\Users\admin_user2"))}

Write-Output " "
ForEach ($prof in $profiles) {
$message = "Deleting " + $prof.LocalPath + "..."
Write-Output $message
$prof.delete()
}

# This is to verify the network is up and active before trying to update Group Policy.
Test-Path Z:\nofolderforyou | Out-Null			# We know this folder/path doesn't exist.
while ($? -eq $False) {
Test-Path \\network\share | Out-Null			# This is a known working folder.
}


Write-Output " "
Write-Output "Cleaning up group policy..."
Remove-Item -Path C:\Windows\System32\GroupPolicy -Recurse -Force
Remove-Item -Path C:\Windows\System32\GroupPolicyUsers -Recurse -Force
Write-Output "Starting policy update..."

gpupdate /force 

Write-Output " "
Write-Output "Cleaning up Wi-Fi..."
netsh wlan delete profile "*"					# This will delete all WiFi profiles that are not installed by GPO.

Write-Output " "
Write-Output "All done. Powering down in 10 seconds."

shutdown -s -t 10								# Can also do reboots instead of shutdowns. PowerShell only would be a "sleep xx ; stop-computer -force"