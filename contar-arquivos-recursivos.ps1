<#
    Script de aprendizagem durante o curso de PowerShell
    Author: Maycon Brito
#>

#Instancia a veriável com o primeiro parâmetro da linha de comando
param($tipoExportacao)

#Determina que o script não continuará executando após um erro
$ErrorActionPreference="Stop"

# Hashtable para a coluna de nome
$nameExpr = @{
    Label="Nome";
    Expression={ $_."Name" }
}

# Hashtable para a coluna de tamanho
$lengthExpr = @{
    Label="Tamanho";
    Expression={ "{0:N2}KB" -f ($_.Length / 1KB) }
}

# Array com os parâmetros a serem selecionados no comando
$params = $nameExpr, $lengthExpr

#CMDLET para buscar recursivamente todos os scripts (.ps1) deste diretório
$resultado = gci -Recurse -File |
    ? Name -like "*.ps1*" |
    select $params

if ($tipoExportacao -eq "HTML") {
    # Busca o conteúdo do arquivo de CSS e
    $estilos = Get-Content .\style\exemplo1.css
    $styleTag = "<style>$estilos</style>"
    $titulo = "Relatorio de scripts do PowerShell"
    $tituloBody = "<h1>$titulo</h1>"

    $resultado |
        ConvertTo-Html -Head $styleTag -Title $titulo -Body $tituloBody |
        Out-File c:\temp\teste.html
} elseif ($tipoExportacao -eq "JSON") {
    $resultado |
        ConvertTo-Json |
        Out-File c:\temp\teste.json
} elseif ($tipoExportacao -eq "CSV") {
    $resultado |
        ConvertTo-CSV -NoTypeInformation |
        Out-File c:\temp\teste.csv
}
