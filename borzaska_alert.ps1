function Start-BorzaskaAlert {

	[CmdletBinding()]
	param (
		[Parameter()][string]$EmailTo #=''
	)

	#Create script
	$ScriptCode = '
	$EmailTo = '+"'"+$EmailTo+"'"+'
    $url = "http://www.elevengusto.hu/"
    $webContent = Invoke-WebRequest -Uri $url
    if(($webContent.Content).Contains("Borzaska")){
        Send-Email -ToEmail $EmailTo -Subject "Borzaska alert" -Body "Today is the day of the mighty Borzaska."
    }
	#Stop-Process -Id $Pid -Force'

	$ScriptPath = "C:\Repo\PSScript\DeployedScripts\BorzaskaAlert.ps1"
	if(test-path($ScriptPath)){
		Remove-Item -path $ScriptPath
	}
	New-Item -ItemType File -Path $ScriptPath -Force | Out-Null
	Add-Content $ScriptPath $ScriptCode

	#Create scheduled job
	$ScheduledJobs = Get-ScheduledJob -ErrorAction SilentlyContinue
	if($ScheduledJobs.Name -ne 'BorzaskaAlert'){
		$trigger = New-JobTrigger -Daily -At 09:00AM
		Register-ScheduledJob -Trigger $trigger -FilePath $ScriptPath -Name BorzaskaAlert | Out-Null
		if(test-path($ScriptPath)){
			#powershell.exe -executionpolicy bypass -file $ScriptPath
		}
	}
	else{
		Write-Host "BorzaskaAlert is already scheduled."
	}
}

#To stop the alert run the following commands:
#Unregister-ScheduledJob -Name BorzaskaAlert -Confirm:$false | Out-Null

