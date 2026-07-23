Param(
  [Parameter(ValueFromPipeline, Position = 0)][String]$FILE_NAME,
  [Parameter(ValueFromPipeline, Position = 1)][bool]$DRAW = $false
)

[string]$GREEN = "`e[32m"
[string]$RESET = "`e[0m"

function file_parser() {
  [string]$ABSOLUTE_PATH = Resolve-Path $FILE_NAME
  [array]$TACHYON_MANIFOLD = @()
  foreach ($line in [System.IO.File]::ReadAllLines($ABSOLUTE_PATH)) {
    [System.Object]$SB = [System.Text.StringBuilder]::new($line)
    $TACHYON_MANIFOLD += , $SB
  }
  
  return $TACHYON_MANIFOLD
}

function beam_splitter([array]$TACHYON_MANIFOLD) {
  [int]$SUM = 0
  [int]$TACHYON_MANIFOLD_0_Length = $TACHYON_MANIFOLD[0].Length
  for ($a = 0; $a -lt $TACHYON_MANIFOLD_0_Length; $a++) {
    [System.Object]$TACHYON_MANIFOLD_0 = $TACHYON_MANIFOLD[0]
    [char]$TACHYON_MANIFOLD_0_a = $TACHYON_MANIFOLD_0[$a]
    if ($TACHYON_MANIFOLD_0_a -eq 'S') {
      [array]$INDEXES += , $a
      if ($DRAW -eq $true) { write-host "$TACHYON_MANIFOLD_0" }
      break
    }
  }
  
  [int]$TACHYON_MANIFOLD_count = $TACHYON_MANIFOLD.count
  for ($a = 1; $a -lt $TACHYON_MANIFOLD_count; $a++) {
    [array]$TMP_INDEX_ARRAY = @()
    [string]$TACHYON_MANIFOLD_a = $TACHYON_MANIFOLD[$a]
    if ("^" -notin $TACHYON_MANIFOLD_a.GetEnumerator()) {
      if ($DRAW -eq $true) {
        [System.Object]$SB = [System.Text.StringBuilder]::new($TACHYON_MANIFOLD_a)
        foreach ($index in $INDEXES) { $SB[$index] = '|' }
        write-host "$SB"
      }

      continue
    }
    
    for ($b = 0; $b -lt $INDEXES.count; $b++) {
      [int]$INDEXES_b = $INDEXES[$b]
      [char]$TACHYON_MANIFOLD_a_b = $TACHYON_MANIFOLD_a[$INDEXES_b]
      if ($TACHYON_MANIFOLD_a_b -eq '^') {
        $SUM++
        [int]$LEFT = $INDEXES_b - 1
        [int]$RIGHT = $INDEXES_b + 1
        if ($LEFT -notin $TMP_INDEX_ARRAY) { $TMP_INDEX_ARRAY += $LEFT }
        if ($RIGHT -notin $TMP_INDEX_ARRAY) { $TMP_INDEX_ARRAY += $RIGHT }
      }
      else {
        if ($INDEXES_b -notin $TMP_INDEX_ARRAY) { $TMP_INDEX_ARRAY += $INDEXES_b }
      }
    }
    
    [array]$INDEXES = $TMP_INDEX_ARRAY
    if ($DRAW -eq $true) { 
      [System.Object]$SB = [System.Text.StringBuilder]::new($TACHYON_MANIFOLD_a)
      foreach ($index in $INDEXES) { $SB[$index] = '|' }
      write-host "$SB"
    }
  }

  return $SUM
}

[array]$TACHYON_MANIFOLD = file_parser
[int]$SUM = beam_splitter -TACHYON_MANIFOLD $TACHYON_MANIFOLD

Write-Host "${GREEN}There are $SUM many times beam will split${RESET}"
