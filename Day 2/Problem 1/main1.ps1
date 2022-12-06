enum GameRoundResult {
    Lost  = 0
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
        $RockMove.Id { return $RockMove}
        $RockMove.Other_Id {return $RockMove}
        $PaperMove.Id {return $PaperMove}
        $PaperMove.Other_Id {$PaperMove}
        $ScissorsMove.Id {return $ScissorsMove}
        $ScissorsMove.Other_Id {$ScissorsMove}
        Default {"Error"}
    }
}

function GetGameResult {
    # [OutputType([GameRoundResult])]
    param ([MoveInfo] $OpponentMove, [MoveInfo] $MyMove) 

    if ($OpponentMove.GetType() -eq $MyMove.GetType()) {
        return [GameRoundResult]::Draw
    }

    if ($OpponentMove.GetType() -eq [Rock]) {
        if ($MyMove.GetType() -eq [Scissors]) {
            return [GameRoundResult]::Lost
        }
        else {
            return [GameRoundResult]::Win
        }
    }

    if ($OpponentMove.GetType() -eq [Paper]) {
        if ($MyMove.GetType() -eq [Rock]) {
            return [GameRoundResult]::Lost
        }
        else {
            return [GameRoundResult]::Win
        }
    }

    if ($OpponentMove.GetType() -eq [Scissors]) {
        if ($MyMove.GetType() -eq [Paper]) {
            return [GameRoundResult]::Lost
        }
        else {
            return [GameRoundResult]::Win
        }
    }
}

function ReadAndParseFile {
    [OutputType([int])]    
    param ([string] $fileName)
    
    [int] $TotalScore = 0
    foreach($line in Get-Content .\$fileName) 
    {
        [MoveInfo] $OpponentMove = GetMoveInfo($line[0])
        [MoveInfo] $MyMove = GetMoveInfo($line[2])
        [GameRoundResult] $GameResult = GetGameResult $OpponentMove $MyMove
        [int] $GameScore = CalculateRoundScore $GameResult $MyMove
        $TotalScore += $GameScore
    }
    return $TotalScore
}

[int] $TotalScore = ReadAndParseFile("..\game_moves.txt")
Write-Output "Total score of all games are: $TotalScore"