$ErrorActionPreference = "Stop" 

$octopusUrl = "http://localhost"
$apiKey = "API-YDZ26JLZD2QRUK3YP9VFUTRYR0"
$role = "api"

#$environment = $OctopusParameters['Octopus.Environment.Name']
$environment = "Dev"

#$numTentacles = $OctopusParameters['NumberOfTentacles']
$numTentacles = 1

$baseName = "Tentacle"
$basePort = 10980

$baseName = $baseName + "_" + $(Get-Date).ToString("yyyyMMdd_HHmm")


for ($tentacleNo = 1; $tentacleNo -le $numTentacles; $tentacleNo++)
{
    $name = $baseName + "_" + $tentacleNo
    $port = $basePort + $tentacleNo - 1

    & "C:\Program Files\Octopus Deploy\Tentacle\Tentacle.exe" create-instance --instance "$name" --config "C:\Octopus\$name\Tentacle-$name.config" --console
    & "C:\Program Files\Octopus Deploy\Tentacle\Tentacle.exe" new-certificate --instance "$name" --if-blank --console
    & "C:\Program Files\Octopus Deploy\Tentacle\Tentacle.exe" configure --instance "$name" --reset-trust --console
    & "C:\Program Files\Octopus Deploy\Tentacle\Tentacle.exe" configure --instance "$name" --home "C:\Octopus\$name" --app "C:\Octopus\Applications\$name" --port "$port" --noListen "False"  --console
    & "C:\Program Files\Octopus Deploy\Tentacle\Tentacle.exe" configure --instance "$name" --trust "E59BD2E42B886007DD0CBA48C633F18CD48FD75F"  --console
    & "netsh" advfirewall firewall add rule "name=Octopus Deploy Tentacle" dir=in action=allow protocol=TCP localport=$port
    & "C:\Program Files\Octopus Deploy\Tentacle\Tentacle.exe" register-with --instance "$name" --name "$name" --publicHostName "localhost" --server "$octopusUrl" --apiKey="$apiKey" --role "$role" --environment "$environment" --comms-style TentaclePassive --policy="The Cattle Yard" --console
    & "C:\Program Files\Octopus Deploy\Tentacle\Tentacle.exe" service --instance "$name" --install --start  --console
}