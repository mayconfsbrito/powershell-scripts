#
# Instala remotamente ad funcionalidades abaixo nos computadores SRV01 até SRV03
# Favor instalar o RSAT do Windows antes de testar o script
#
function Install-WindowsFeatureInServers {
    param(
        [String[]] $computers,
        [String] $featureName
    )

    $jobScriptBlock = {
        param(
            [String] $computerName,
            [String] $featureName
        )
        Install-WindowsFeature -ComputerName $computerName -Name $featureName
    }

    $computers | ForEach-Object {
        Start-Job -Name "JOB_$_" -ScriptBlock $jobScriptBlock -ArgumentList ($_, $featureName)
    }

    $resultado = Receive-Job (Get-Job)
    $resultado

    Remove-Job (Get-Job)
}