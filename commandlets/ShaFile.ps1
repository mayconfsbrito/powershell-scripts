# Isto é apenas uma função, não um commandlet
function Get-FileSHA1() {

    param (
        [Parameter(
            ValueFromPipeline = $true, # Permite que o argumento $filePath possa ser recebido do pipeline
            ValueFromPipelineByPropertyName = "FullName", # Permite a chamada da propriedade FullName automaticamente de nossos objetos passados por parâmetro
            Mandatory = $true # Define que o parâmetro é obrigatório
        )]
        [String] $filePath
    )

    begin {
        $sha1 = New-Object System.Security.Cryptography.SHA1Managed
        $prettyHashSB = New-Object System.Text.StringBuilder
    }

    process {
        $fileContent = Get-Content $filePath
        $fileBytes = [System.Text.Encoding]::UTF8.GetBytes($fileContent)

        $hash = $sha1.ComputeHash($fileBytes)

        foreach ($byte in $hash) {
            $hexaNotation = $byte.ToString("x2")
            $prettyHashSB.Append($hexaNotation) > $null
        }

        $prettyHashSB.ToString()
        $prettyHashSB.Clear() > $null
    }

    end {
        $sha1.Dispose()
    }

}

# . path desse script para inicializar e disponibilizar este Commandlet no powershell
