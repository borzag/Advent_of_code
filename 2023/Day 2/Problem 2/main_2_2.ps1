# Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
# Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
# Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
# Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
# Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green

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
        foreach ($colorCount in $DrawString.Split(',').Trim()) {
            $draw = GetRegexpValues $colorCount $this.DrawRegex
            switch ($draw[1]) {
                "red" { $this.RedCubesCount += $draw[0] }
                "blue" { $this.BlueCubesCount += $draw[0] }
                "green" { $this.GreenCubesCount += $draw[0] }
                Default {
                    Write-Error "Parsing of cube color and count failed!"
                    Write-Host "Parsing of cube color and count failed! '$draw'"
                }
            }
        }
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

    [int] GetPowerOfCubes() {
        [int] $maxRedCubes = 1
        [int] $maxBlueCubes = 1
        [int] $maxGreenCubes = 1
        foreach ($drawString in $this.Draws.Split(';')) {
            $draw = [Draw]::new($drawString)
            if ($draw.RedCubesCount -gt $maxRedCubes) {
                $maxRedCubes = $draw.RedCubesCount
            }
            if ($draw.BlueCubesCount -gt $maxBlueCubes) {
                $maxBlueCubes = $draw.BlueCubesCount
            }
            if ($draw.GreenCubesCount -gt $maxGreenCubes) {
                $maxGreenCubes = $draw.GreenCubesCount
            }
        }

        return $maxRedCubes * $maxBlueCubes * $maxGreenCubes
    }
}

function ReadAndParseFile([string] $fileName) {
    [OutputType([int])]
    
    [int] $SumOfPowerOfCubes = 0
    foreach ($line in Get-Content $fileName) {
        [Game] $Game = [Game]::new($line)
        $GamePowerOfCubes = $Game.GetPowerOfCubes()     
        Write-Host "Game $($Game.GameNumber); Power of cubes: $GamePowerOfCubes"
        $SumOfPowerOfCubes += $GamePowerOfCubes
    }
    return $SumOfPowerOfCubes
}

$SumOfPowerOfCubes = ReadAndParseFile(Join-Path $PSScriptRoot "..\Data.txt")
Write-Host "Sum of possible games : $SumOfPowerOfCubes"
