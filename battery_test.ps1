<#
Commenting out the Start-Process to be used on an as needed basis.
It only measures when the machine is awake, which is a good way to track real life usage.
The YouTube video is good for an unattended test of runtime just based on video playback.
It doesn't accurately track user workloads, so the result would be a best case scenario.
#>
#Start-Process 'C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe' -ArgumentList "https://www.youtube.com/watch?v=jFbkujZ0OuI" 
sleep 5
clear
$count = 0
while ($? -eq $True){
date -UFormat %H:%M:%S | Tee-Object -Append $($env:USERPROFILE + '\battery_test.txt')
$count++
Write-Host $("Machine has been awake for " + $count + " minutes.") |  Tee-Object -Append $($env:USERPROFILE + '\battery_test.txt')
sleep 60
}