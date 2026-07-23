Param(
  [Parameter(ValueFromPipeline, Position = 0)][String]$FILE_NAME
)

[string]$GREEN = "`e[32m"
[string]$RESET = "`e[0m"
[string]$ABSOLUTE_PATH = Resolve-Path $FILE_NAME
[int]$SUM = 0

foreach ($JOLTAGE_BANK in [System.IO.File]::ReadAllLines($ABSOLUTE_PATH)) {
  [int]$MAX = 0
  [int]$MAX_INDEX = 0
  [int]$SECOND = 0
  [int]$JOLTAGE_BANK_Length = $JOLTAGE_BANK.Length
  [int]$a_goal = $JOLTAGE_BANK_Length - 1
  for ($a = 0; $a -lt $a_goal; $a++) {
    [int]$N = "$($JOLTAGE_BANK[$a])"
    if ($MAX -lt $N) {
      $MAX = $N
      $MAX_INDEX = $a
    }
  }

  [int]$a_start = $MAX_INDEX + 1
  for ($a = $a_start; $a -lt $JOLTAGE_BANK_Length; $a++) {
    [int]$N = "$($JOLTAGE_BANK[$a])"
    if ($SECOND -lt $N) { $SECOND = $N }
  }

  [int]$FINAL = "$MAX" + "$SECOND"
  $SUM += $FINAL
}

Write-Host "${GREEN}^^SUM is $SUM^^${RESET}"