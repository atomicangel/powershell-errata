<# Function that copies files. I use it in my PowerShell profile to copy a set of files to a local folder to make sure I have a copy.

Since for my use case I needed something simple, I only do a .LastWriteTime on the source file and a Test-File to make sure it copied.
I chose Start-BitsTransfer in this instance as I personally find it more reliable than Copy-File and I was sticking to PowerShell native code.
Robocopy would also be a good option, especially if you are copying a larger amount of data than just a small set of files or if you wanted to modify this to handle directories.
As for output of what it's pulling, you could show the whole path by doing:
Write-Host $("Copying " + $file "...)

I wanted a cleaner output so I used a (Get-ChildItem).Name to grab the file name and extension.
#>

function Copy-Files {
# This copies inventory files if they have changed since the last pull.

$source=("\\network_share\file1","\\network_share\file2","\\network_share\file3","\\network_share\file4")
$destination=("C:\Users\Public\file1","C:\Users\Public\file2","C:\Users\Public\file3","C:\Users\Public\file4")
$index=0

ForEach ($file in $destination) { # This assumes you have coded your source and destination to the same amount of files.
	
If ( (Get-ChildItem $source[$index]).LastWriteTime -ne (Get-ChildItem $destination[$index] -ErrorAction SilentlyContinue).LastWriteTime ) {
Write-Host $("Copying " + $(Get-ChildItem $file).Name + "...")
Start-BitsTransfer -Source $source[$index] -Destination $destination[$index]
sleep 1
}

If (-not (Test-Path $file)) {
Write-Host ($file + " did not copy or does not exist due to another error.")
}
$index++
}
}