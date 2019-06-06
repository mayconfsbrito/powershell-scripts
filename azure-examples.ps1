# Verifica se existem comandos do módulo AzureRM
Get-Command -Module AzureRM*

#Verifica todos os comandos do Azure que possuem a palavra "firewall"
Get-Command *firewall* -Module AzureRM*

#Altera a política de execução de comandos no PowerShell
Set-ExecutionPolicy Unrestrict

#Conecta com a conta do Azure
Connect-AzureRmAccount

#Procura por comandos que tenham resourcegroup no nome e sejam do módulo AzureRM
Get-Command *resourcegroup* -Module AzureRM*

#Ajuda para o seguinte comando
get-help New-AzureRmResourceGroup

#Criação de um novo grupo de recursos com nome e localização definida
New-AzureRmResourceGroup `
    -Name "ps-casadocodigo-rg" `
    -Location "South Central US"

#Cria um novo servidor de banco de dados SQL Server com as credenciais retornadas pelo comando Get-Credential que solicita as credenciais para o usuário
New-AzureRmSqlServer `
    -Name "ps-casadocodigo-alura-sql-srv" `
    -ResourceGroupName "ps-casadocodigo-rg" `
    Location "south central us" `
    -SqlAdministratorCredentials ( Get-Credential )

#Cria um novo banco de dados contendo um tamanho máximo de 50GB e uma camada S0 para performance/DTU
New-AzureRmSqlDatabase `
    -ResourceGroupName "ps-casadocodigo-rg" `
    -ServerName "pdfs-casadocodigo-alura-sql-srv" `
    -Name "ps-casadocodigo-sql-bd" `
    -MaxSizeBytes 50GB `
    -RequestedServiceObjectiveName "S0"

#Retorna os servidores criados no azure
Get-AzureRmSqlServer

#Adiciona uma nova regra no firewall para o servidor sql permitindo o acesso do IP especificado (minha máquina)
New-AzureRmSqlServerFirewallRule `
    -ResourceGroupName "ps-casadocodigo-rg" `
    -ServerName "ps-casadocodigo-alura-sql-srv" `
    -Name "MaquinaAdministracao" `
    -StartIpAddress "138.219.88.128" `
    -EndIpAddress "138.219.88.128"

#Adiciona regra de firewall para acesso ao servidor sql a partir de todos os serviços do azure
New-AzureRmSqlServerFirewallRule `
>> -ResourceGroupName "ps-casadocodigo-rg" `
>> -ServerName "ps-casadocodigo-alura-sql-srv" `
>> -Name AllowAllWindowsAzureIps `
>> -StartIpAddress "0.0.0.0" `
>> -EndIpAddress "0.0.0.0"

---------------------------------------------------------------------------------
--Executar o Script de Criação do Banco de Dados no Azure Através no PowerShell--
(Não funcionou)
---------------------------------------------------------------------------------
$scriptSQL = Get-Content C:\Users\maycon.fernando\Downloads\Scripts.sql
$connectionString =
    "Data Source=ps-casadocodigo-alura-sql-srv.database.windows.net;" +
    "Initial Catalog=ps-casadocodigo-sql-bd;" +
    "User ID=Administrador;" +
    "Password=alura!123;"
$connection = new-object system.data.SqlClient.SQLConnection($connectionString)
$command = new-object system.data.sqlclient.sqlcommand($scriptSQL, $connection)
$connection.Open()

$adapter = New-Object System.Data.sqlclient.sqlDataAdapter $command
$dataset = New-Object System.Data.DataSet
$adapter.Fill($dataSet) | Out-Null

$connection.Close()
--------------------------------------------------------------------------------
---------------------------------------------------------------------------------

# Cria um nobo AppServicePlan para criar a aplicação web depois
New-AzureRmAppServicePlan `
    -Name 'ps-casadocodigo-appserviceplan' `
    -Location 'South Central US' `
    -ResourceGroupName 'ps-casadocodigo-rg' `
    -Tier 'S1'

#Cria o webapp com o appserviceplan criado antes
New-AzureRmWebApp `
    -ResourceGroupName 'ps-casadocodigo-rg' `
    -Name 'pscasadocodigo-alura' `
    -Location 'South Central US' `
    -AppServicePlan 'ps-casadocodigo-appserviceplan'

#Salvando o xml de publicação do webapp em um arquivo
$arquivoDePublicacao =
    [xml] (Get-AzureRmWebAppPublishingProfile `
                -Name 'pscasadocodigo-alura' `
                -ResourceGroupName 'ps-casadocodigo-rg')
$arquivoDePublicacao.Save('c:\temp\psacasadocodigo-alura.PublishSettings')
