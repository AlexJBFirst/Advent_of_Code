Param(
	[Parameter(ValueFromPipeline, Position=0)][String]$FILE_NAME
)

[string]$GREEN="`e[32m"
[string]$RESET="`e[0m"
[string]$ABSOLUTE_PATH = Resolve-Path $FILE_NAME

function fileparser(){
  [array]$FILE_CONTENT = [System.IO.File]::ReadAllLines($ABSOLUTE_PATH).Trim()
  [array]$MATH_PROBLEMS = @()
  
  foreach ($item in $FILE_CONTENT){$MATH_PROBLEMS += ,($item -split "\s+")}

  return $MATH_PROBLEMS
}

function math_solver(){
  [int64]$SUM = 0

  for ($a=0;$a -lt $MATH_PROBLEMS[0].count;$a++){
    [int64]$TMP_BUFFER = 0

    for ($b=0;$b -lt ($MATH_PROBLEMS.count - 1);$b++){
      [int]$NUMBER = "$($MATH_PROBLEMS[$b][$a])"
      
      if($TMP_BUFFER -eq 0){
        $TMP_BUFFER += $NUMBER
        continue
      }

      switch($MATH_PROBLEMS[-1][$a]){
        '*' {$TMP_BUFFER *= $NUMBER}
        '+' {$TMP_BUFFER += $NUMBER}
        '-' {$TMP_BUFFER -= $NUMBER}
        '/' {$TMP_BUFFER /= $NUMBER}
      }
    }

    $SUM += $TMP_BUFFER
  }

  return $SUM
}

[array]$MATH_PROBLEMS = fileparser
[int64]$SUM = math_solver

"${GREEN}Grand total found by adding together all of the answers is: $SUM${RESET}"
