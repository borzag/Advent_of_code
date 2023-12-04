# Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
# Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
# Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
# Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
# Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green

[int] $AllowedRedCubes = 12 
[int] $AllowedGreenCubes = 13
[int] $AllowedBlueCubes = 14

function GetRegexpValues([string] $searchString, [Regex] $regExp) {   
    $allMatches = $regExp.Match($searchString)
    if (-Not $allMatches.Success) {
        Write-Output "No match found!"
    }
    [string[]] $result = @()
    foreach ($match in $allMatches.Groups) {
        if ($match.Value -eq $searchString) {
            continue
        }
        $result += $match.Value
    }
    return $result
}

class Draw {
    [int] $RedCubesCount = 0
    [int] $GreenCubesCount = 0
    [int] $BlueCubesCount = 0
    [Regex] $DrawRegex = [Regex]::new(' ?(\d+) (red|blue|green)')
    Draw([string] $DrawString) {
        foreach ($color in $DrawString.Split(',').Trim()) {
            $draw = GetRegexpValues $color $this.DrawRegex
            switch ($draw[1]) {
                "red" { $this.RedCubesCount += $draw[0] }
                "blue" { $this.BlueCubesCount += $draw[0] }
                "green" { $this.GreenCubesCount += $draw[0] }
                Default {
                    Write-Error "Parsing of cube color and count failed!"
                    Write-Debug "Parsing of cube color and count failed! '$draw'"
                }
            }
        }
    }

    [bool] IsDrawPossible() {
        return $this.RedCubesCount -le $Global:AllowedRedCubes -and
        $this.GreenCubesCount -le $Global:AllowedGreenCubes -and
        $this.BlueCubesCount -le $Global:AllowedBlueCubes
    }
}

class Game {
    [int] $GameNumber
    [string] $Draws
    [Regex] $GameRegex = [Regex]::new('Game (\d+): ?(.*)')
    
    Game ([string] $GameLine) {
        $gamelineArray = GetRegexpValues $GameLine $this.GameRegex
        $this.GameNumber = $gamelineArray[0]
        $this.Draws = $gamelineArray[1]      
    }

    [int] GetPossibleGameNumber() {
        [bool] $drawResult = $true
        foreach ($draw in $this.Draws.Split(';')) {
            $drawResult = $drawResult -and [Draw]::new($draw).IsDrawPossible()
        }
        if ($drawResult -eq $true) {
            return $this.GameNumber
        }
        return 0
    }
}

function ReadAndParseFile([string] $fileName) {
    [OutputType([int])]
    
    [int] $SumOfPossibleGames = 0    
    foreach ($line in Get-Content $fileName) {
        [int] $PossibleGameNumber = [Game]::new($line).GetPossibleGameNumber()     
        Write-Host "Possible game nubmer: $PossibleGameNumber"
        $SumOfPossibleGames += $PossibleGameNumber
    }
    return $SumOfPossibleGames
}

$SumOfPossibleGames = ReadAndParseFile(Join-Path $PSScriptRoot "..\Data.txt")
Write-Host "Sum of possible games : $SumOfPossibleGames"
