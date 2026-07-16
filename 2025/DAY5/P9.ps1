Param(
  [Parameter(ValueFromPipeline, Position = 0)][String]$FILE_NAME
)

[string]$GREEN = "`e[32m"
[string]$RESET = "`e[0m"
[int64]$SUM = 0

function file_parser() {
  [array]$RANGEs = @()
  [array]$IDs = @() 
  [string]$ABSOLUTE_PATH = Resolve-Path $FILE_NAME
  
  foreach ($string in [System.IO.File]::ReadAllLines($ABSOLUTE_PATH)) {
    if ($string -match '^\d+-\d+') {
      [int64]$MIN, [int64]$MAX = $string -split "-"
      $RANGEs += , @($MIN, $MAX)
      continue
    }
    elseif ('' -eq $string) { continue }

    $IDs += [int64]$string
  }
  
  return $RANGEs, $IDs
}

function fresh_checker() {
  param (
    [Int64]$ID
  )

  foreach ($RANGE in $RANGEs) {
    if ($ID -le $RANGE[1] -and $ID -ge $RANGE[0]) { return $true }
  }
}

[array]$RANGEs, [array]$IDs = file_parser

foreach ($ID in $IDs) {
  [bool]$TEST = fresh_checker -ID $ID
  if ($TEST -eq $true) { $SUM++ }
}

Write-Host "${GREEN}There are $SUM available fresh ingredients${RESET}"
