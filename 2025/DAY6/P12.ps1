Param(
  [Parameter(ValueFromPipeline, Position = 0)][String]$FILE_NAME
)

[string]$GREEN = "`e[32m"
[string]$RESET = "`e[0m"

function fileparser() {
  [string]$ABSOLUTE_PATH = Resolve-Path $FILE_NAME
  [array]$TMP_PROBLEMS = @()

  foreach ($item in [System.IO.File]::ReadAllLines($ABSOLUTE_PATH)) {
    [System.Object]$SB = [System.Text.StringBuilder]::new($item)
    $TMP_PROBLEMS += $SB
  }
  
  [array]$INDEXES = @()
  [int]$INDEX_WITH_OPERATOR = 0

  for ($a = 0; $a -lt $TMP_PROBLEMS[-1].Length; $a++) {
    if ($TMP_PROBLEMS[-1][$a] -ne ' ') { $INDEX_WITH_OPERATOR = $a }

    $INDEXES += $INDEX_WITH_OPERATOR
  }

  return $INDEXES, $TMP_PROBLEMS
}

function math_solver() {
  [int64]$TMP_SUM = 0
  [int64]$SUM = 0

  for ($a = 0; $a -lt $TMP_PROBLEMS[0].Length; $a++) {
    [string]$NUMBER = ''
    [NullString]$DIGIT = $null

    for ($b = 0; $b -lt ($TMP_PROBLEMS.count - 1); $b++) { $NUMBER += "$($TMP_PROBLEMS[$b][$a])" }
    
    if ($NUMBER -notmatch '^\s+$') { [int]$DIGIT = $NUMBER }

    if ($TMP_SUM -eq 0) {
      $TMP_SUM += $DIGIT
      continue
    }

    if ($null -eq $DIGIT) {
      $SUM += $TMP_SUM
      $TMP_SUM = 0
      continue
    }

    switch ($($TMP_PROBLEMS[-1][$INDEXES[$a]])) {
      '*' { $TMP_SUM *= $DIGIT }
      '+' { $TMP_SUM += $DIGIT }
      '-' { $TMP_SUM -= $DIGIT }
      '/' { $TMP_SUM /= $DIGIT }
    }
  }

  $SUM += $TMP_SUM
  return $SUM
}

[array]$INDEXES, [array]$TMP_PROBLEMS = fileparser
[int64]$SUM = math_solver
Write-Host "${GREEN} Grand total found by adding together all of the answers is: $SUM ${RESET}"
