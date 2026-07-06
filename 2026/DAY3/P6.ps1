Param(
	[Parameter(ValueFromPipeline, Position=0)][String]$FILE_NAME,
	[Parameter(ValueFromPipeline, Position=1)][String]$GOAL_DEPTH=12
)

[string]$GREEN="`e[32m"
[string]$RESET="`e[0m"
[string]$ABSOLUTE_PATH = Resolve-Path $FILE_NAME
[Int64]$SUM=0

function nested_sum {
  param (
    [int]$CURRENT_DEPTH,
    [int]$INDEX=0
  )

  [int]$MAX = 0
  [int]$MAX_INDEX = 0
  
  for ($a=$INDEX;$a -lt ($JOLTAGE_BANK.Length - $GOAL_DEPTH + $CURRENT_DEPTH + 1);$a++){
    [int]$N = "$($JOLTAGE_BANK[$a])"
    
    if ($MAX -lt $N){
      $MAX = $N
      $MAX_INDEX = $a
    }
  }

  $CURRENT_DEPTH++
  if ($CURRENT_DEPTH -le $GOAL_DEPTH){
    return "$MAX$(nested_sum -CURRENT_DEPTH $CURRENT_DEPTH -INDEX ($MAX_INDEX+1))"
  }
}

foreach ($JOLTAGE_BANK in [System.IO.File]::ReadAllLines($ABSOLUTE_PATH)){
  $SUM += nested_sum -CURRENT_DEPTH 0
}

"${GREEN}^^SUM is $SUM^^${RESET}"
