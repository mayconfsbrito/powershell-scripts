param($diretorio)

$ErrorActionPreference = "Stop"

. .\commandlets\ShaFile.ps1

$arquivos = Get-ChildItem $diretorio -File
foreach ($item in $arquivos.FullName ) {
    $hashItem = Get-FileSHA1 $item
    Write-Host "O Hash do arquivo $item eh $hashItem !"
}