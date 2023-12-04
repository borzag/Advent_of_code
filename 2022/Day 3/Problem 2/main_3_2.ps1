class GroupContent {
    [Char[]] $Rucksack1 = ""
    [Char[]] $Rucksack2 = ""
    [Char[]] $Rucksack3 = ""
    [string] $Priority = "@abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"    

    GroupContent ([string] $Rucksack1, [string] $Rucksack2, [string] $Rucksack3) {
        $this.Rucksack1 = $Rucksack1.ToCharArray()
        $this.Rucksack2 = $Rucksack2.ToCharArray()     
        $this.Rucksack3 = $Rucksack3.ToCharArray()     
    }

    [Char[]] FindCommonContent() {
        [Char[]] $CommonContent = "";
        foreach ($Rucksack1Item in $this.Rucksack1) {
            if ($this.Rucksack2.Contains($Rucksack1Item) -and
                $this.Rucksack3.Contains($Rucksack1Item)) {
                if (-not($CommonContent.Contains($Rucksack1Item))) {
                    $CommonContent += $Rucksack1Item                    
                }
            }
        }
        return $CommonContent;
    }

    [int] GetGroupBadgeSum() {
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
    [string] $Rucksack1 = "";
    [string] $Rucksack2 = "";
    [string] $Rucksack3 = "";
    foreach ($line in Get-Content .\$fileName) {     
        if ($Rucksack1 -eq "") {
            $Rucksack1 = $line
            continue
        }
        if ($Rucksack2 -eq "") {
            $Rucksack2 = $line
            continue
        }
        if ($Rucksack3 -eq "") {
            $Rucksack3 = $line            
        }
        [GroupContent] $Group = [GroupContent]::new($Rucksack1, $Rucksack2, $Rucksack3)
        $TotalPrioritySum += $Group.GetGroupBadgeSum()
        $Rucksack1 = $Rucksack2 = $Rucksack3 = ""
    }
    return $TotalPrioritySum
}

[int] $TotalPrioritySum = ReadAndParseFile "..\inputkdata.txt"
Write-Output "Total sum of priorities : $TotalPrioritySum"