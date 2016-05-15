function Delete-Tentacles([string]$baseName, [int]$numTentacles)
{

    for ($tentacleNo = 1; $tentacleNo -le $numTentacles; $tentacleNo++)
    {
        $name = $baseName + $tentacleNo
        & "C:\Program Files\Octopus Deploy\Tentacle\Tentacle.exe" service --instance "$name" --stop --uninstall
        & "C:\Program Files\Octopus Deploy\Tentacle\Tentacle.exe" delete-instance --instance "$name"
    }
}

Delete-Tentacles "Tentacle_20160514_2208_" 2
#Delete-Tentacles "Tentacle_20160514_2319_" 8