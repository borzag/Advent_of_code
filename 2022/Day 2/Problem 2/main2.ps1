enum GameRoundResult {
    None = -1
    Loose = 0
    Draw = 3
    Win = 6
}

[Rock] $RockMove = [Rock]::new()
[Paper] $PaperMove = [Paper]::new()
[Scissors] $ScissorsMove = [Scissors]::new()

class MoveInfo {
    [string] $Id
    [string] $Other_Id
    [Int16]  $Score

    MoveInfo ([string] $Id, [string] $Other_Id, [Int16] $Score) {
        $this.Id = $Id
        $this.Other_Id = $Other_Id
        $this.Score = $Score
    }
}

class Rock : MoveInfo {    
    Rock() : base("A", "X", 1) {}
}

class Paper: MoveInfo {
    Paper() : base("B", "Y", 2) {}
}

class Scissors: MoveInfo {
    Scissors() : base("C", "Z", 3) {}
}

function CalculateRoundScore {    
    param (
        [GameRoundResult] $RoundScore,
        [MoveInfo] $MyMove
    )
    return [int]$RoundScore + $MyMove.Score
}

function GetMoveInfo {
    [OutputType([MoveInfo])]
    param ([string] $MoveId)        
    
    switch ($MoveId) {
        $RockMove.Id { return $RockMove }
        $RockMove.Other_Id { return $RockMove }
        $PaperMove.Id { return $PaperMove }
        $PaperMove.Other_Id { $PaperMove }
        $ScissorsMove.Id { return $ScissorsMove }
        $ScissorsMove.Other_Id { $ScissorsMove }
        Default { Write-Error "Invalid MoveId ('$MoveId') in method GetMoveInfo()!" }
    }
}

function GetGameResult {
    [OutputType([GameRoundResult])]
    param ( [string] $GameResult)
        
    switch ($GameResult) {
        "X" { return [GameRoundResult]::Loose }
        "Y" { return [GameRoundResult]::Draw }
        "Z" { return [GameRoundResult]::Win }
        Default { Write-Error "Invalid GameResult ('$GameResult') in method GetGameResult()!" }
    }
}

function GetMyMoveInGame {
    [OutputType([MoveInfo])]
    param ([MoveInfo] $OpponentMove, [GameRoundResult] $GameResult) 

    if ($GameResult -eq [GameRoundResult]::Loose) {
            if ($OpponentMove.GetType() -eq [Rock]) {
                return $ScissorsMove
            }
            if ($OpponentMove.GetType() -eq [Paper]) {
                return $RockMove
            }
            if ($OpponentMove.GetType() -eq [Scissors]) {
                return $PaperMove
            }
        }
        
    if ($GameResult -eq  [GameRoundResult]::Draw) {  
        if ($OpponentMove.GetType() -eq [Rock]) {
            return $RockMove
        }
        if ($OpponentMove.GetType() -eq [Paper]) {
            return $PaperMove
        }
        if ($OpponentMove.GetType() -eq [Scissors]) {
            return $ScissorsMove
        }
    }
    
    if ($GameResult -eq [GameRoundResult]::Win) {  
        if ($OpponentMove.GetType() -eq [Rock]) {
            return $PaperMove
        }
        if ($OpponentMove.GetType() -eq [Paper]) {
            return $ScissorsMove
        }
        if ($OpponentMove.GetType() -eq [Scissors]) {
            return $RockMove
        }
    }
    Write-Error "Invalid GameRoundResult ('$GameResult') in method GetMyMoveInGame()!" 
}

function ReadAndParseFile {
    [OutputType([int])]
    param ([string] $fileName)
    
    [int] $TotalScore = 0
    foreach ($line in Get-Content .\$fileName) {        
        [MoveInfo] $OpponentMove = GetMoveInfo($line[0])
        [GameRoundResult] $GameResult = GetGameResult($line[2])
        [MoveInfo] $MyMove = GetMyMoveInGame $OpponentMove $GameResult
        [int] $GameScore = CalculateRoundScore $GameResult $MyMove
        $TotalScore += $GameScore
    }
    return $TotalScore
}

[int] $TotalScore = ReadAndParseFile "..\game_moves.txt"
Write-Output "Total score of all games are: $TotalScore"