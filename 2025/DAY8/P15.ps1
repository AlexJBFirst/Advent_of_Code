Param(
  [Parameter(ValueFromPipeline, Position = 0)][String]$FILE_NAME,
  [Parameter(ValueFromPipeline, Position = 1)][Int16]$SELECTOR = 1000
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
  
  return $JUNCTION_BOXes
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
      [int64]$item1_int = "$($item1[0])$($item1[1])$($item1[2])"
      [int64]$item2_int = "$($item2[0])$($item2[1])$($item2[2])"
      $Distances.item1[$Distances_index] = @($EUC_A_B, $item1_int, $item2_int, $item1, $item2)
      $Distances_index++
    }
  }

  [array]$SORTED_MAP = $Distances.item1 | Sort-Object { $_[0][0] } | Select-Object -First $SELECTOR
  return $SORTED_MAP  
}

function link_finder() {
  [int]$HT_INDEX = 0
  [hashtable]$Linked_items = @{}
  [bool]$iter = $true
  [int]$SORTED_MAP_COUNT = $SORTED_MAP.count
  [array]$INDEXES = @()
  $INDEXES += 0
  $Linked_items[$HT_INDEX] = @($SORTED_MAP[0][1], $SORTED_MAP[0][2])

  while ($INDEXES.count -ne $SORTED_MAP_COUNT) {
    while ($iter -eq $true) {
      $iter = $false

      for ($a = 0; $a -lt $SORTED_MAP_COUNT; $a++) {
        if ($a -in $INDEXES) { continue }
        [int64]$ITEM1 = $SORTED_MAP[$a][1]
        [int64]$ITEM2 = $SORTED_MAP[$a][2]
        [array]$LINK = $Linked_items[$HT_INDEX]

        if ($LINK.count -eq 0) {
          $Linked_items[$HT_INDEX] = @($ITEM1, $ITEM2)
          $INDEXES += $a
          continue
        }

        if ($ITEM1 -in $LINK) {
          if ($ITEM2 -in $LINK) {
            $INDEXES += $a
            continue
          }
          
          $INDEXES += $a
          $Linked_items[$HT_INDEX] += $ITEM2
          $iter = $true
        }
        elseif ($ITEM2 -in $LINK) {
          if ($ITEM1 -in $LINK) {
            $INDEXES += $a
            continue
          }

          $INDEXES += $a
          $Linked_items[$HT_INDEX] += $ITEM1
          $iter = $true
        }
      }
    }

    $HT_INDEX++
    $iter = $true
  }
  
  return $Linked_items
}

function circuits_size_sum() {
  [array]$SIZEs = @()
  foreach ($LINK in $LINKED_ITEMS.GetEnumerator()) { $SIZEs += $LINK.Value.count }
  [int64]$SUM = 1
  foreach ($SIZE in ($SIZEs | Sort-Object -Descending | Select-Object -First 3)) { $SUM *= $SIZE }
  return $SUM
}

[System.Object]$JUNCTION_BOXes = file_parser
[array]$SORTED_MAP = euclid_dist_solver
[hashtable]$LINKED_ITEMS = link_finder
[int64]$SUM = circuits_size_sum

Write-Host "${GREEN}Sum is: $SUM, after multiply together the sizes of the three largest circuits of $SELECTOR junction boxes pairs which are closest together.${RESET}"
