cd $PSScriptRoot

. ".\Initialize.ps1"

$containername = "$($settings.name)-dev"
$name = Read-Host -Prompt "Enter name of container (enter for $containerName)"
if ($name) {
    $containername = $name
}

. ".\Install-BCContainerHelper.ps1" `
    -buildEnv Local `
    -BCContainerHelperPath $userProfile.BCContainerHelperPath

. ".\Create-Container.ps1" `
    -buildEnv Local `
    -containerName $containerName `
    -artifact $imageversion.artifact `
    -imageName $imageVersion.imageName `
    -credential $credential `
    -licensefile $licensefile

UpdateLaunchJson -name "Local Sandbox ($containername)" -server "http://$containername"
