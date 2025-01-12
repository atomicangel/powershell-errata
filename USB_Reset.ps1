<# Quick script for re-initializing the USB Root hubs and any devices in an error state.

Made this to try and fix an issue with USB NICs not being detected by the OS, which led to the computers not finishing the imaging process.
The intention is that it would force the USB hub to reset the USB NIC and that it would hopefully succeed with a DHCP request.
#>


$USB_Root = Get-PnpDevice -FriendlyName "*USB Root*" # This pulls all USB Root hubs info.

ForEach ($device in $USB_Root){
    devcon disable $("@" + $device.InstanceID)  # This disables each hub by device Instance ID.
}

$devices = Get-PNPDevice -FriendlyName "*USB*" -Status Error  # This pulls all devices in an Error State, meaning it's disabled or otherwise non-functional.

ForEach ($device in $devices) {
    devcon enable $('@' +$device.InstanceID)                  # This attempts to re-enable all devices that are in an error state.
}

If ($devices = Get-PNPDevice -FriendlyName "*USB*" -Status Error ) {   # If devices are still listed in an error state, restart them and enable them.
    $devices = Get-PnpDevice -FriendlyName "*USB*" -Status Error
    
    ForEach ($device in $devices){
        devcon restart $("@" + $device.InstanceID)                     # Restart all devices in an error state.
        devcon enable $("@" + $device.InstanceID)                      # Now enable those devices.
    
}