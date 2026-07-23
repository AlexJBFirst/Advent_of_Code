Param(
  [Parameter(ValueFromPipeline, Position = 0)][String]$FILE_NAME
)

[string]$GREEN = "`e[32m"
[string]$RESET = "`e[0m"
[int64]$SUM = 0

function file_parser() {
  [string]$ABSOLUTE_PATH = Resolve-Path $FILE_NAME
  [array]$RANGEs = @()
  foreach ($string in [System.IO.File]::ReadAllLines($ABSOLUTE_PATH)) {
    if ('' -eq $string) { break }

    [int64]$MIN, [int64]$MAX = $string -split "-"
    $RANGEs += , @($MIN, $MAX)
  }
  
  return $RANGEs
}

function merger([array]$RANGEs) {
  [array]$MERGED = @()
  [int]$RANGEs_count = $RANGEs.count
  :main for ($a = 0; $a -lt $RANGEs_count; $a++) {
    [array]$RANGEs_a = $RANGEs[$a]
    [int64]$RANGEs_a_0 = $RANGEs_a[0]
    [int64]$RANGEs_a_1 = $RANGEs_a[1]
    foreach ($ITEM in $MERGED) {
      [int64]$ITEM_0 = $ITEM[0]
      [int64]$ITEM_1 = $ITEM[1]
      if ($RANGEs_a_0 -ge $ITEM_0) {
        if ($RANGEs_a_1 -le $ITEM_1) { continue main }
        
        if ($RANGEs_a_0 -le $ITEM_1) {
          $ITEM[1] = $RANGEs_a_1
          continue main
        }
      }
    }

    $MERGED += , $RANGEs_a
  }

  return $MERGED
}

[array]$RANGEs = file_parser
$RANGES = $RANGEs | Sort-Object -Property { $_[0][0] }
[array]$MERGED = merger -RANGES $RANGES
foreach ($item in $MERGED) {
  [int64]$item_0 = $item[0]
  [int64]$item_1 = $item[1]
  $SUM += $item_1 - $item_0 + 1
}

Write-Host "${GREEN}There are $SUM available fresh ingredients${RESET}"
