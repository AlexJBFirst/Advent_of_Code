Param(
  [Parameter(ValueFromPipeline)][String]$FILE_NAME
)

[string]$GREEN = "`e[32m"
[string]$RESET = "`e[0m"
[string]$ABSOLUTE_PATH = Resolve-Path $FILE_NAME
[int]$DIAL = 50
[int]$COUNT = 0

foreach ($line in [System.IO.File]::ReadAllLines($ABSOLUTE_PATH)) {
  [string]$DIRECTION = $line[0]
  [int]$NUMBER = $line[1..($line.Length - 1)] -join ""
  
  if ($DIRECTION -eq 'L') {
    if ($DIAL -eq 0) { $DIAL += 100 }
    $DIAL -= $NUMBER
    while ($DIAL -lt 0) { $DIAL += 100 }
    if ($DIAL -eq 0) { $COUNT++ }
  }
  else {
    $DIAL += $NUMBER
    while ($DIAL -ge 100 ) { $DIAL -= 100 }
    if ($DIAL -eq 0) { $COUNT++ }
  }
}

Write-Host "${GREEN}FINAL Count is: $COUNT${RESET}"