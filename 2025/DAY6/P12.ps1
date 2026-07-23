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
  [int]$TMP_PROBLEMS_operators_Length = $TMP_PROBLEMS[-1].Length
  for ($a = 0; $a -lt $TMP_PROBLEMS_operators_Length; $a++) {
    [string]$TMP_PROBLEMS_operator_a = $TMP_PROBLEMS[-1][$a]
    if ($TMP_PROBLEMS_operator_a -ne ' ') { $INDEX_WITH_OPERATOR = $a }

    $INDEXES += $INDEX_WITH_OPERATOR
  }

  return $INDEXES, $TMP_PROBLEMS
}

function math_solver([array]$INDEXES, [array]$TMP_PROBLEMS ) {
  [int64]$TMP_SUM = 0
  [int64]$SUM = 0
  [int]$TMP_PROBLEMS_Length = $TMP_PROBLEMS[0].Length
  [int]$TMP_PROBLEMS_count_1 = $TMP_PROBLEMS.count - 1
  for ($a = 0; $a -lt $TMP_PROBLEMS_Length; $a++) {
    [string]$NUMBER = ''
    [NullString]$DIGIT = $null
    for ($b = 0; $b -lt $TMP_PROBLEMS_count_1; $b++) { 
      [string]$TMP_PROBLEMS_b_a = $TMP_PROBLEMS[$b][$a]
      $NUMBER += $TMP_PROBLEMS_b_a
    }
    
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

    [char]$TMP_PROBLEMS_operator = $TMP_PROBLEMS[-1][$INDEXES[$a]]
    switch ($TMP_PROBLEMS_operator) {
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
[int64]$SUM = math_solver -INDEXES $INDEXES -TMP_PROBLEMS $TMP_PROBLEMS
Write-Host "${GREEN} Grand total found by adding together all of the answers is: $SUM ${RESET}"
