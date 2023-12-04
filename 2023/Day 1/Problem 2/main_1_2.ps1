enum Digits {
    one = 1
    two
    three
    four 
    five
    six 
    seven
    eight
    nine
}

function GetIntValue() {
    [OutputType([int])]
    param([string] $value)

    [int] $intValue = 0;
    if ([int32]::TryParse($value, [ref] $intValue)) {
        return $intValue
    }
    else {
        [Digits] $DigitValue = [Enum]::Parse([Digits], $value)
        return [int]$DigitValue
    }
}

function GetLineCalibration {
    [OutputType([string])]
    param ([string] $line)       

    function GetRegexpValue ([Regex] $RegExp ) {
        $lineMatches = $RegExp.Match($line)
        if (-Not $lineMatches.Success) {
            Write-Line "No digit found!"
        }
        return $lineMatches.Value
    }
    
    [string] $regExp = '(\d|one|two|three|four|five|six|seven|eight|nine)'
    $firstNumberRegExp = [Regex]::new($regExp)
    [string] $firsttNumber = GetRegexpValue($firstNumberRegExp)
    $lastNumberRegExp = [Regex]::new($regExp, [System.Text.RegularExpressions.RegexOptions]::RightToLeft)
    [string] $lastNumber = GetRegexpValue($lastNumberRegExp)

    return [Int32]::Parse("$(GetIntValue($firsttNumber))$(GetIntValue($lastNumber))")
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
