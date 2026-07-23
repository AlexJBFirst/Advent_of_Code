Param(
  [Parameter(ValueFromPipeline, Position = 0)][String]$FILE_NAME
)

[string]$GREEN = "`e[32m"
[string]$RESET = "`e[0m"

function fileparser() {
  [string]$ABSOLUTE_PATH = Resolve-Path $FILE_NAME
  [array]$FILE_CONTENT = [System.IO.File]::ReadAllLines($ABSOLUTE_PATH).Trim()
  [array]$MATH_PROBLEMS = @()
  foreach ($item in $FILE_CONTENT) { $MATH_PROBLEMS += , ($item -split "\s+") }

  return $MATH_PROBLEMS
}

function math_solver([array]$MATH_PROBLEMS) {
  [int64]$SUM = 0
  [int]$MATH_PROBLEMS_count_1 = $MATH_PROBLEMS.count - 1
  [int]$MATH_PROBLEMS_0_count = $MATH_PROBLEMS[0].count
  for ($a = 0; $a -lt $MATH_PROBLEMS_0_count; $a++) {
    [int64]$TMP_BUFFER = 0
    [char]$MATH_PROBLEM_operator = $MATH_PROBLEMS[-1][$a]
    for ($b = 0; $b -lt $MATH_PROBLEMS_count_1; $b++) {
      [string]$MATH_PROBLEMS_b_a = $MATH_PROBLEMS[$b][$a]
      [int]$NUMBER = $MATH_PROBLEMS_b_a
      if ($TMP_BUFFER -eq 0) {
        $TMP_BUFFER += $NUMBER
        continue
      }

      switch ($MATH_PROBLEM_operator) {
        '*' { $TMP_BUFFER *= $NUMBER }
        '+' { $TMP_BUFFER += $NUMBER }
        '-' { $TMP_BUFFER -= $NUMBER }
        '/' { $TMP_BUFFER /= $NUMBER }
      }
    }

    $SUM += $TMP_BUFFER
  }

  return $SUM
}

[array]$MATH_PROBLEMS = fileparser
[int64]$SUM = math_solver -MATH_PROBLEMS $MATH_PROBLEMS

Write-Host "${GREEN}Grand total found by adding together all of the answers is: $SUM${RESET}"
