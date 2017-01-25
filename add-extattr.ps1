#colors (duh, we hooman)
function colorgreen {process { Write-Host $_ -ForegroundColor Green }}
function colorred {process { Write-Host $_ -ForegroundColor Red }}
 
#gui(ish) input
$user 	= Read-Host 'Username'
 
#check if $user exists
$usercheck = Get-ADUser -Filter {sAMAccountName -eq $user}
if ($usercheck -eq $null) {
	Write-Output "$user does not exist in AD" | colorred
}
else {
 
	#get primary smtp
	$smtp = Get-ADUser $user -Properties mail | Select-Object -ExpandProperty mail
	 
	#build user@sub.domain.com
	#this will grab primarysmtpaddress (everything before @-sign and rebuild)
	$trimsmtp = $smtp.IndexOf("@")
	$newmail = $smtp.Substring(0, $trimsmtp)
	$newmail = $newmail + "@sub.domain.com"
	 
	#check if ext6 is empty
	$ext6check = Get-ADUser -Identity $user -Properties *
	$ext6 = $ext6check.extensionattribute6
	if ($ext6 -eq $null) {
	    #set extensionAttribute6 to $newmail
	    Set-ADUser –Identity $user -add @{"extensionattribute6"="$newmail"}
	    Write-Output "extensionattribute6 for $user set to $newmail" | colorgreen
	}
	else {
	    #value exists in ext6
	    Write-Output "Value already exists, extensionattribute6: $ext6" | colorred
	}

	#check if ext4 is empty
	$ext4check = Get-ADUser -Identity $user -Properties *
	$ext4 = $ext4check.extensionattribute4
	if ($ext6 -eq $null) {
	    #set passwd for extensionAttribute4
	    $passwd = Get-Random -Maximum 99999999 -Minimum 10000000
	    Set-ADUser –Identity $user -add @{"extensionattribute4"="$passwd"}
	    Write-Output "extensionattribute4 for $user set to $passwd" | colorgreen
	}
	else {
	    #value exists in ext4
	    Write-Output "Value already exists, extensionattribute4: $ext4" | colorred
	}
	#we done nao
}