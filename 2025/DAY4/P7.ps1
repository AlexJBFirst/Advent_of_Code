Param(
  [Parameter(ValueFromPipeline, Position = 0)][String]$FILE_NAME
)

[string]$GREEN = "`e[32m"
[string]$RESET = "`e[0m"

function file_parser() {
  [string]$ABSOLUTE_PATH = Resolve-Path $FILE_NAME
  [array]$FILE_CONTENT = [System.IO.File]::ReadAllLines($ABSOLUTE_PATH)
  [array]$LARGE_GRID = @()
  
  for ($a = 0; $a -lt $FILE_CONTENT.count; $a++) {
    [array]$Symbol_array = @()
    
    for ($b = 0; $b -lt $FILE_CONTENT[$a].Length; $b++) {
      if ($FILE_CONTENT[$a][$b] -eq '@') {
        $Symbol_array += [int]1
        continue
      }
      $Symbol_array += [int]0
    }

    $LARGE_GRID += , $Symbol_array
  }

  return $LARGE_GRID
}

function roll_finder() {
  [int]$COUNTER = 0

  for ($a = 0; $a -lt $LARGE_GRID.count; $a++) {
    for ($b = 0; $b -lt $LARGE_GRID[$a].count; $b++) {
      [int]$ROLL_COUNT = 0

      if ($LARGE_GRID[$a][$b] -eq 0) { continue }
      
      for ($c = ($a - 1); $c -le ($a + 1); $c++) {
        if ($c -lt 0 -or $c -gt ($LARGE_GRID.count - 1)) { continue }

        for ($d = ($b - 1); $d -le ($b + 1); $d++) {
          if ($d -lt 0 -or ($c -eq $a -and $b -eq $d) -or $d -gt ($LARGE_GRID[$a].count - 1)) { continue }

          if ($LARGE_GRID[$c][$d] -eq 1) { $ROLL_COUNT++ }
        }
      }
      
      if ($ROLL_COUNT -lt 4) { $COUNTER++ }
    }
  }

  return $COUNTER
}

[array]$LARGE_GRID = file_parser
[int]$SUM = roll_finder

Write-Host "${GREEN}There are $SUM rolls of paper can be accessed by a forklift${RESET}"
