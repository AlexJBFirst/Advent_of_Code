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

function beam_splitter() {
  [int]$SUM = 0

  for ($a = 0; $a -lt $TACHYON_MANIFOLD[0].Length; $a++) {
    if ($($TACHYON_MANIFOLD[0][$a]) -eq 'S') {
      [array]$INDEXES += , $a
      if ($DRAW -eq $true) { write-host "$($TACHYON_MANIFOLD[0])" }
      break
    }
  }
  
  for ($a = 1; $a -lt $TACHYON_MANIFOLD.count; $a++) {
    [array]$TMP_INDEX_ARRAY = @()
    
    if ("^" -notin "$($TACHYON_MANIFOLD[$a])".GetEnumerator()) {
      if ($DRAW -eq $true) {
        [System.Object]$SB = [System.Text.StringBuilder]::new("$($TACHYON_MANIFOLD[$a])")
        foreach ($index in $INDEXES) { $SB[$index] = '|' }
        write-host "$SB"
      }

      continue
    }
    
    for ($b = 0; $b -lt $INDEXES.count; $b++) {
      if ($TACHYON_MANIFOLD[$a][$INDEXES[$b]] -eq '^') {
        $SUM++
        [int]$LEFT = $INDEXES[$b] - 1
        [int]$RIGHT = $INDEXES[$b] + 1
        
        if ($LEFT -notin $TMP_INDEX_ARRAY) { $TMP_INDEX_ARRAY += $LEFT }
        if ($RIGHT -notin $TMP_INDEX_ARRAY) { $TMP_INDEX_ARRAY += $RIGHT }
      }
      else {
        if ($INDEXES[$b] -notin $TMP_INDEX_ARRAY) { $TMP_INDEX_ARRAY += $INDEXES[$b] }
      }
    }
    
    [array]$INDEXES = $TMP_INDEX_ARRAY
    if ($DRAW -eq $true) { write-host "$($TACHYON_MANIFOLD[$a])" }
  }

  return $SUM
}

[array]$TACHYON_MANIFOLD = file_parser
[int]$SUM = beam_splitter

Write-Host "${GREEN}There are $SUM many times beam will split${RESET}"
