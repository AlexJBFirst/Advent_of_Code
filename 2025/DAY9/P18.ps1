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

function find_internal_sqare_area([array]$X, [array]$Y, [int]$STRING_COUNT) {
  [int64]$SUM = 0
  [int64]$MATH = 0
  [array]$GOAL_ARR = @()
  for ($a = 0; $a -lt $STRING_COUNT; $a++) {
    Write-Progress -Activity "Trying to find the largest area..." -Status "Processing line $a of $STRING_COUNT" -PercentComplete (($a / $STRING_COUNT) * 100)
    [int]$X_a = $X[$a]
    [int]$Y_a = $Y[$a]
    [int]$B_START_INDEX = $a + 1
    :main for ($b = $B_START_INDEX; $b -lt $STRING_COUNT; $b++) {
      [int]$X_b = $X[$b]
      [int]$Y_b = $Y[$b]
      if ($X_a -eq $X_b -or $Y_a -eq $Y_b) { continue }
      
      [int]$X_ab_min = $X_a
      [int]$X_ab_max = $X_b
      if ($X_a -gt $X_b) {
        [int]$X_ab_min = $X_b
        [int]$X_ab_max = $X_a
      }
      
      [int]$Y_ab_min = $Y_a
      [int]$Y_ab_max = $Y_b
      if ($Y_a -gt $Y_b) {
        [int]$Y_ab_min = $Y_b
        [int]$Y_ab_max = $Y_a
      }

      $MATH = ($X_ab_max - $X_ab_min + 1) * ($Y_ab_max - $Y_ab_min + 1)
      if ($MATH -lt $SUM) { continue }
      
      for ($c = 0; $c -lt $STRING_COUNT; $c++) {
        [int]$X_c = $X[$c]
        [int]$Y_c = $Y[$c]
        [int]$X_d = $X[($c + 1) % $STRING_COUNT]
        [int]$Y_d = $Y[($c + 1) % $STRING_COUNT]
        [int]$X_cd_min = $X_c
        [int]$X_cd_max = $X_d
        if ($X_c -gt $X_d) {
          $X_cd_min = $X_d
          $X_cd_max = $X_c
        }
          
        [int]$Y_cd_min = $Y_c
        [int]$Y_cd_max = $Y_d
        if ($Y_c -gt $Y_d) {
          $Y_cd_min = $Y_d
          $Y_cd_max = $Y_c
        } 

        if ($Y_cd_min -eq $Y_cd_max) {
          if ($Y_cd_min -gt $Y_ab_min -and $Y_cd_max -lt $Y_ab_max) {
            if ($X_cd_min -lt $X_ab_min -and $X_cd_max -gt $X_ab_max) { continue main }
            if ($X_cd_min -gt $X_ab_min -and $X_cd_min -le $X_ab_max) { continue main }
            if ($X_cd_max -gt $X_ab_min -and $X_cd_max -le $X_ab_max) { continue main }
          }
        }
        else {
          if ($X_cd_min -gt $X_ab_min -and $X_cd_max -lt $X_ab_max) {
            if ($Y_cd_min -lt $Y_ab_min -and $Y_cd_max -gt $Y_ab_max) { continue main }
            if ($Y_cd_min -gt $Y_ab_min -and $Y_cd_min -le $Y_ab_max) { continue main }
            if ($Y_cd_max -gt $Y_ab_min -and $Y_cd_max -le $Y_ab_max) { continue main }
          }
        }
      }

      $SUM = $MATH
      $GOAL_ARR = @($X_a, $Y_a, $X_b, $Y_b)
    }
  }
  
  return $SUM, $GOAL_ARR
}

[array]$X, [array]$Y, [int]$STRING_COUNT = file_parser
[int64]$SUM, $GOAL_ARR = find_internal_sqare_area -X $X -Y $Y -STRING_COUNT $STRING_COUNT

Write-Host "${GREEN}If we take two red tiles as opposite corners,the rectangle X1-$($GOAL_ARR[0]):Y1-$($GOAL_ARR[1]);X2-$($GOAL_ARR[2]):Y2-$($GOAL_ARR[3]) has the largest area: $SUM${RESET}"
