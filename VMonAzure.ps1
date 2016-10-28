$family="Windows Server 2012 R2 Datacenter"
$image=Get-AzureVMImage | where { $_.ImageFamily -eq $family } | sort PublishedDate -Descending | select -ExpandProperty ImageName -First 1
$vmname="Sample"
$vmsize="Medium"
$vm1=New-AzureVMConfig -Name $vmname -InstanceSize $vmsize -ImageName $image

$cred=Get-Credential -Message "Type the name and password of the local administrator account."
$vm1 | Add-AzureProvisioningConfig -Windows -AdminUsername $cred.Username -Password $cred.GetNetworkCredential().Password

$vm1 | Set-AzureSubnet -SubnetNames "BackEnd"

$vm1 | Set-AzureStaticVNetIP -IPAddress 192.168.244.4

$disksize=20
$disklabel="DCData"
$lun=0
$hcaching="None"
$vm1 | Add-AzureDataDisk -CreateNew -DiskSizeInGB $disksize -DiskLabel $disklabel -LUN $lun -HostCaching $hcaching

$svcname="Azure-TailspinToys"
$vnetname="AZDatacenter"
New-AzureVM –ServiceName $svcname -VMs $vm1 -VNetName $vnetname