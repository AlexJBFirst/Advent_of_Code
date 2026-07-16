Param(
  [Parameter(ValueFromPipeline, Position = 0)][String]$FILE_NAME
)

[string]$GREEN = "`e[32m"
[string]$RESET = "`e[0m"

function file_parser() {
  [string]$ABSOLUTE_PATH = Resolve-Path $FILE_NAME
  [array]$FILE_CONTENT = [System.IO.File]::ReadAllLines($ABSOLUTE_PATH)
  [int]$STRING_COUNT = $FILE_CONTENT.Count
  [System.Object]$JUNCTION_BOXes = [System.Tuple]::Create([array[]]::new($STRING_COUNT))
  
  for ($a = 0; $a -lt $STRING_COUNT; $a++) {
    [string]$line = $FILE_CONTENT[$a]
    [array]$TMP_ARR = @()
    foreach ($element in $line -split ',') { $TMP_ARR += [int]$element }
    $JUNCTION_BOXes.item1[$a] = $TMP_ARR
  }
  
  return $JUNCTION_BOXes, $STRING_COUNT
}

function euclid_dist_solver() {
  [int]$Boxes_count = $JUNCTION_BOXes.item1.count
  [int64]$Termial = ($Boxes_count * ($Boxes_count + 1)) / 2 - $Boxes_count
  [System.Object]$Distances = [System.Tuple]::Create([array[]]::new($Termial))
  [int]$Distances_index = 0

  for ($a = 0; $a -lt ($Boxes_count - 1); $a++) {
    [array]$item1 = $JUNCTION_BOXes.item1[$a]

    for ($b = ($a + 1); $b -lt $Boxes_count; $b++) {
      [array]$item2 = $JUNCTION_BOXes.item1[$b]
      [int]$NUM1 = $item1[0] - $item2[0]
      [int]$NUM2 = $item1[1] - $item2[1]
      [int]$NUM3 = $item1[2] - $item2[2]
      [int64]$EUC_A_B = $NUM1 * $NUM1 + $NUM2 * $NUM2 + $NUM3 * $NUM3
      [int64]$item1_1 = "$($item1[0])$($item1[1])$($item1[2])"
      [int64]$item2_1 = "$($item2[0])$($item2[1])$($item2[2])"
      $Distances.item1[$Distances_index] = @($EUC_A_B, $item1_1, $item2_1, $item1, $item2)
      $Distances_index++
    }
  }

  [array]$SORTED_MAP = $Distances.item1 | Sort-Object { $_[0][0] }
  return $SORTED_MAP  
}

function link_finder() {
  [array]$LINKED_CIRCUIT = @()
  [array]$INDEXES = @()
  $INDEXES += 0
  $LINKED_CIRCUIT += [int64]$SORTED_MAP[0][1]
  $LINKED_CIRCUIT += [int64]$SORTED_MAP[0][2]
  
  while ($LINKED_CIRCUIT.Count -ne $STRING_COUNT) {
    for ($a = 1; $a -lt $SORTED_MAP.count; $a++) {
      if ($a -in $INDEXES) { continue }
      [int64]$LINK1 = $SORTED_MAP[$a][1]
      [int64]$LINK2 = $SORTED_MAP[$a][2]

      if ($LINK1 -in $LINKED_CIRCUIT) {
        if ($LINK2 -in $LINKED_CIRCUIT) {
          $INDEXES += $a
          continue
        }
        
        $LINKED_CIRCUIT += $LINK2
        $INDEXES += $a
        break
      }
      elseif ($LINK2 -in $LINKED_CIRCUIT) {
        $LINKED_CIRCUIT += $LINK1
        $INDEXES += $a
        break
      }
    }
  }
  
  return $SORTED_MAP[$a]
}

[System.Object]$JUNCTION_BOXes, [int]$STRING_COUNT = file_parser
[array]$SORTED_MAP = euclid_dist_solver
[array]$GOAL_ELEMENT = link_finder
[int64]$SUM = $GOAL_ELEMENT[3][0] * $GOAL_ELEMENT[4][0]

Write-Host "${GREEN}Multiplication of X coordinates results in: $SUM.${RESET}"
