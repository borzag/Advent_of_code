function GetLineCalibration {
    [OutputType([string])]
    param ([string] $line)       

    function GetRegexpValue ($RegExp ) {
        $lineMatches = $line | Select-String $RegExp  
        return $lineMatches.Matches[0].Groups[1]
    }
    
    $firstNumberRegExp = [Regex]::new('^[^\d]*(\d)')
    [string] $firsttNumber = GetRegexpValue($firstNumberRegExp)
    $lastNumberRegExp = [Regex]::new('[\d]*.*(\d)[^\d]*')
    [string] $lastNumber = GetRegexpValue($lastNumberRegExp)

    return $firsttNumber + $lastNumber
}

function ReadAndParseFile {
    [OutputType([int])]
    param ([string] $fileName)
    
    [int] $CalibrationSum = 0    
    foreach($line in Get-Content $fileName) {
        $CalibrationSum += GetLineCalibration($line)         
    }
    return $CalibrationSum
}

$CalibrationSum = ReadAndParseFile(Join-Path $PSScriptRoot "..\InputData.txt")
Write-Host "The calibration sum is: $CalibrationSum"
