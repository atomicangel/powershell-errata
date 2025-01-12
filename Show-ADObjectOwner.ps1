<#
Working on a script that can show the AD object owner.
Would like to have it show in a table or something.

A ForEach loop + Prompt-List would enable the ability to do a Format-Table output.
#>
$creds=Get-Credential

[string]$computername=Read-Host -Prompt "Enter computer name"
$computer=Get-ADComputer $computername -Properties * -Credential $creds
Write-Host $computer.NTSecurityDescriptor.Owner
