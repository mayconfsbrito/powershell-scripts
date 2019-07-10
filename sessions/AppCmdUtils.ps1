#
# Inicia uma sessão remota do powershell nos computadores passados por parâmetro e cria um novo
# pool do IIS
# A execução ocorre parelelamente em vários jobs, um para cada computador
# Exemplo de uso:
#   . .\AppCmdUtils.ps1
#   Add-ApplicationPool -ComputersName ("SRV01", "SRV02", "SRV03") -ApplicationPoolName "Aplicacoes" | fl
#
function Add-ApplicationPool {
    param (
        [String[]] $ComputersName,
        [String] $ApplicationPoolName
    )

    # Abre um nova sessão para cada computador
    $sessions = $ComputersName | ForEach-Object { New-PSSession -ComputerName $_ }

    # Executa o comando de criação de pool para cada sessão
    $jobs = $sessions | ForEach-Object {
        Invoke-command -Session $_ -ScriptBlock {
            "Executando no computador: $env:COMPUTERNAME"
            $appCmdArgs = "add apppol /name:$($args[0]) /managedRuntimeVersion:v4.0 /managedPipelineMode:Integrated"
              C:\Windows\System32\inetsrv\appcmd.exe $appCmdArgs.Split(' ')
        } -ArgumentList $ApplicationPoolName -AsJob
    }

    # Aguarda os jobs terminarem e imprime o texto de cada execução
    $jobs | Wait-Job | Select-Object @{Expression={ Receive-Job $_ };Label="Resultado"}, "Name"

    # Remove os jobs
    $jobs | Remove-Job

    # Remove as sessões
    $sessions | Remove-PSSession

}