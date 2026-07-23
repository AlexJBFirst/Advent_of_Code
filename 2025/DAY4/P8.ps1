Param(
  [Parameter(ValueFromPipeline, Position = 0)][String]$FILE_NAME,
  [Parameter(ValueFromPipeline, Position = 1)][bool]$DRAW_TO_TERMINAL = $false
)

[string]$GREEN = "`e[32m"
[string]$RESET = "`e[0m"

function file_parser() {
  [string]$ABSOLUTE_PATH = Resolve-Path $FILE_NAME
  [array]$FILE_CONTENT = [System.IO.File]::ReadAllLines($ABSOLUTE_PATH)
  [array]$LARGE_GRID = @()
  [int]$FILE_CONTENT_count = $FILE_CONTENT.count
  for ($a = 0; $a -lt $FILE_CONTENT_count; $a++) {
    [array]$Symbol_array = @()
    [string]$FILE_CONTENT_a = $FILE_CONTENT[$a]
    [int]$FILE_CONTENT_a_Lenght = $FILE_CONTENT_a.Length
    for ($b = 0; $b -lt $FILE_CONTENT_a_Lenght; $b++) {
      [char]$FILE_CONTENT_a_b = $FILE_CONTENT_a[$b]
      if ($FILE_CONTENT_a_b -eq '@') {
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
  [array]$ROLLS_INDEXES = @()
  [int]$LARGE_GRID_count = $LARGE_GRID.count
  [int]$LARGE_GRID_count_1 = $LARGE_GRID.count - 1
  for ($a = 0; $a -lt $LARGE_GRID_count; $a++) {
    [array]$LARGE_GRID_a = $LARGE_GRID[$a]
    [int]$LARGE_GRID_a_count = $LARGE_GRID_a.Count
    [int]$LARGE_GRID_a_count_1 = $LARGE_GRID_a.Count - 1
    [int]$a_up_row_index = $a - 1
    [int]$a_bottom_row_index = $a + 1
    for ($b = 0; $b -lt $LARGE_GRID_a_count; $b++) {
      [int]$LARGE_GRID_a_b = $LARGE_GRID_a[$b]
      if ($LARGE_GRID_a_b -eq 0) { continue }
      
      [int]$ROLL_COUNT = 0
      [int]$b_left_index = $b - 1
      [int]$b_right_index = $b + 1
      for ($c = $a_up_row_index; $c -le $a_bottom_row_index; $c++) {
        if ($c -lt 0 -or $c -gt $LARGE_GRID_count_1) { continue }

        for ($d = $b_left_index; $d -le $b_right_index; $d++) {
          if ($d -lt 0 -or ($c -eq $a -and $b -eq $d) -or $d -gt $LARGE_GRID_a_count_1) { continue }
          
          [int]$LARGE_GRID_c_d = $LARGE_GRID[$c][$d]
          if ($LARGE_GRID_c_d -eq 1) { $ROLL_COUNT++ }
        }
      }
      
      if ($ROLL_COUNT -lt 4) {
        $COUNTER++
        $ROLLS_INDEXES += , @($a, $b)
      }
    }
  }

  foreach ($INDEX in $ROLLS_INDEXES) {
    $INDEX0 = $INDEX[0]
    $INDEX1 = $INDEX[1]
    $LARGE_GRID[$INDEX0][$INDEX1] = 0
  }

  return $COUNTER
}

function draw() {
  foreach ($row in $LARGE_GRID) {
    foreach ($element in $row) {
      if ($element -eq 0) {
        Write-host "." -NoNewline -ForegroundColor RED
        continue
      }
      Write-host "@" -NoNewline -ForegroundColor GREEN
    }
    ""
  }
}

[array]$LARGE_GRID = file_parser
while ($TMP_SUM -ne 0) {
  if ($DRAW_TO_TERMINAL -eq $true) { draw; "" }

  [int]$TMP_SUM = roll_finder
  $SUM += $TMP_SUM
}

if ($DRAW_TO_TERMINAL -eq $true) { draw }

Write-Host "${GREEN}There are $SUM rolls of paper can be accessed by a forklift${RESET}"