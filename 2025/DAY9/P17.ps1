Param(
  [Parameter(ValueFromPipeline, Position = 0)][String]$FILE_NAME
)

[string]$GREEN = "`e[32m"
[string]$RESET = "`e[0m"

function file_parser() {
  [string]$ABSOLUTE_PATH = Resolve-Path $FILE_NAME
  [array]$FILE_CONTENT = [System.IO.File]::ReadAllLines($ABSOLUTE_PATH)
  [int]$STRING_COUNT = $FILE_CONTENT.count
  [array]$X = [int[]]::new($STRING_COUNT)
  [array]$Y = [int[]]::new($STRING_COUNT)
  for ($a = 0; $a -lt $STRING_COUNT; $a++) {
    [string]$string = $FILE_CONTENT[$a]
    $X[$a], $Y[$a] = $string -split ','
  }
  
  return $X, $Y, $STRING_COUNT
}

function area_finder([array]$X, [array]$Y, [int]$STRING_COUNT) {
  [int64]$SUM = 0
  [array]$GOAL_ARR = @()
  for ($a = 0; $a -lt $STRING_COUNT; $a++) {
    [int]$X_a = $X[$a]
    [int]$Y_a = $Y[$a]
    [int]$B_START_INDEX = $a + 1
    for ($b = $B_START_INDEX; $b -lt $STRING_COUNT; $b++) {
      [int64]$MATH = 0
      [int]$X_b = $X[$b]
      [int]$Y_b = $Y[$b]
      [int]$LENX = $X_a - $X_b
      [int]$LENY = $Y_a - $Y_b
      if ($LENX -lt 0) { $LENX = $LENX * -1 }
      
      if ($LENY -lt 0) { $LENY = $LENY * -1 }

      $MATH = ($LENX + 1) * ($LENY + 1)
      if ($MATH -gt $SUM) {
        $SUM = $MATH
        $GOAL_ARR = $X_a, $Y_a, $X_b, $Y_b
      }
    }
  }

  return $SUM, $GOAL_ARR
}

[array]$X, [array]$Y, [int]$STRING_COUNT = file_parser
[int64]$SUM, [array]$GOAL_ARR = area_finder -X $X -Y $Y -STRING_COUNT $STRING_COUNT
Write-Host "${GREEN}The largest area is: $SUM with rectangle: 'X:$($GOAL_ARR[0]),Y:$($GOAL_ARR[1])' - 'X:$($GOAL_ARR[2]),Y:$($GOAL_ARR[3])'${RESET}"
