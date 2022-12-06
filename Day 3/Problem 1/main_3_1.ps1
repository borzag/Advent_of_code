class RucksackContent {
    [Char[]] $Compartment1Content = ""
    [Char[]] $Compartment2Content = ""
    [string] $Priority = "@abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"    

    RucksackContent ([string] $TotalContent) {
        [int] $CompartmentLength = $TotalContent.Length / 2
        $this.Compartment1Content = $TotalContent.Substring(0, $CompartmentLength).ToCharArray()
        $this.Compartment2Content = $TotalContent.Substring($CompartmentLength, $CompartmentLength).ToCharArray()     
    }

    [Char[]] FindCommonContent() {
        [Char[]] $CommonContent = "";
        foreach ($Compartment1Item in $this.Compartment1Content) {
            if ($this.Compartment2Content.Contains($Compartment1Item)) {
                if (-not($CommonContent.Contains($Compartment1Item))) {
                    $CommonContent += $Compartment1Item                    
                }
            }
        }
        return $CommonContent;
    }

    [int] GetRucksackPrioritySum() {
        [int] $PrioritySum = 0

        foreach ($CommonItem in $this.FindCommonContent()) {
            $PrioritySum += $this.Priority.indexof($commonItem)
        }
        return $PrioritySum
    }
}

function ReadAndParseFile {
    [OutputType([int])]
    param ([string] $fileName)
    
    [int] $TotalPrioritySum = 0
    foreach ($line in Get-Content .\$fileName) {        
        [RucksackContent] $Rucksack = [RucksackContent]::new($line)
        $TotalPrioritySum += $Rucksack.GetRucksackPrioritySum()
    }
    return $TotalPrioritySum
}

[int] $TotalPrioritySum = ReadAndParseFile "..\inputdata.txt"
Write-Output "Total sum of priorities : $TotalPrioritySum"