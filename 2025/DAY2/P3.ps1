Param(
  [Parameter(ValueFromPipeline, Position = 0)][String]$FILE_NAME
)

[string]$GREEN = "`e[32m"
[string]$RESET = "`e[0m"
[string]$ABSOLUTE_PATH = Resolve-Path $FILE_NAME
[int64]$ID_COUNT = 0

foreach ($item in $([System.IO.File]::ReadAllLines($ABSOLUTE_PATH) -split "[`r`n,]+" | Where-Object { $_.Length -gt 0 })) {
  [int64]$FLOOR, [int64]$CEILING = $item -split '-'
  
  if ($FLOOR -gt $CEILING) { continue }
  
  for ($LENGTH = 1; $LENGTH -le 14; $LENGTH++) {
    [int]$multiplier = [Math]::Pow(10, $LENGTH) + 1
    [int]$minX = [Math]::Pow(10, $LENGTH - 1)
    [int]$maxX = [Math]::Pow(10, $LENGTH) - 1
    [int64]$minVal = $minX * $multiplier
    [int64]$maxVal = $maxX * $multiplier
    
    if ($minVal -gt $CEILING) { break }
    
    if ($maxVal -lt $FLOOR) { continue }
    
    [int]$startK = [Math]::Max($minX, [Math]::Ceiling($FLOOR / $multiplier))
    [int]$endK = [Math]::Min($maxX, [Math]::Floor($CEILING / $multiplier))

    if ($startK -le $endK) {
      [int]$count = ($endK - $startK) + 1
      [int]$sumX = $count * ($startK + $endK) / 2
      $ID_COUNT += ($sumX * $multiplier)
    }
  }
}

Write-Host "${GREEN}Invalid IDS SUM: $ID_COUNT${RESET}"
