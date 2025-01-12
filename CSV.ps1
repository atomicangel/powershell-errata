
# Old version
function Get-Computers ($designation,$range) {
If ($range -ne 0 ) { 
$range = Invoke-Expression $range
Foreach($item in $range) {
If ($item -lt 10) { $reference = $designation + "0" + $item 
} Else { 
$reference = $designation + $item 
}
$computer = Get-ADComputer -Filter "Name -like '$reference'" -Properties *

$list.Add($computer) | Out-Null
}
} Else {
$reference = $designation + "*"
$computer = Get-ADComputer -Filter "Name -like '$reference'" -Properties *
ForEach ( $item in $computer) {
$list.Add($item) | Out-Null
}
}
Write-Host " "
}


# This function grabs all the computers in the AD based on input gathered previously.
function Get-Computers ($designation,$range) {
$server = <ip address or hostname>
$search_base = "OU=Computers,DC=example,DC=org"
If ($range -ne '*' ) { 
$range = Invoke-Expression $range
Foreach($item in $range) {
# This is because in an environment I worked in the original administrator padded machine names with zeros. Isn't necessary otherwise.
If ($item -lt 10) {
$reference = $designation + "0" + $item 
} Else { 
$reference = $designation + $item 
}
$computer_Objects = Get-ADComputer -Server $server -Credential $global:creds -SearchBase $search_base -Filter "Name -like '$reference'" -Properties *
$list.Add($computer_Objects) | Out-Null
}
} Else {
$reference = $designation + "*"
$computer_Objects = Get-ADComputer -Server $server -Credential $global:creds -SearchBase $search_base -Filter "Name -like '$reference'" -Properties *
ForEach ( $item in $computer_Objects) {
$list.Add($item) | Out-Null
}
}
Write-Host " "
}

# This function grabs all computers matching input parameters and lists the requested output.

# Wrote the prompt as a function to reduce code waste.
function Prompt-List {

$list.Clear()
Write-Output "This can work with both ranges and single stations/laptops."
Write-Output "When doing a single station, enter in it's full name as the designation, and a * for the 'range'."
Write-Output "When doing a range or series, enter in the designation in the following format: SHWC10S or JHTEACHLT etc."
Write-Output "When asking for the range the syntax is x..y e.g. 1..30 or whatever range you need."
Write-Output "Example: Designation: JHTEACHLT    Range: 1..10"
Write-Output "In that example, it will search for all machines matching that range."

$designation = Read-Host -Prompt "Enter the full name or a part of the name to search a range"
$range = Read-Host -Prompt "Enter a number range or put * to do all machines in designation"


Get-Computers $designation $range
}

Prompt-List

<# Code for handling CSV files and auto entering a service tag.
This also requires the Get-Computer and Prompt-List functions, but this works to cycle through a list of machines.
#>
$outfile = 'C:\output_file.csv'
$csvfile = Import-CSV $outfile # Only need to import the file once before running the loop.
foreach ($computer in $list) {
	$computer.name
	$output = Invoke-Command -ComputerName $computer.name -ScriptBlock { $bios_info = get-wmiobject -class win32_bios ; $bios_info.serialnumber }
	$csvfile.MachineName = $computer.name
	$csvfile.ServiceTag = $output
	$csvfile.AssetID = Read-Host -Prompt "Enter Inventory Tag"
	$csvfile | Export-Csv $outfile -Append
}