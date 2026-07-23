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
  [array]$X = [int[]]::new($STRING_COUNT)
  [array]$Y = [int[]]::new($STRING_COUNT)
  [array]$Z = [int[]]::new($STRING_COUNT)
  for ($a = 0; $a -lt $STRING_COUNT; $a++) {
    [string]$line = $FILE_CONTENT[$a]
    $X[$a], $Y[$a], $Z[$a] = $line -split ','
  }
  
  return $X, $Y, $Z, $STRING_COUNT
}

function euclid_dist_solver([array]$X, [array]$Y, [array]$Z, [int]$STRING_COUNT, [int]$SELECTOR) {
  [int64]$Termial = ($STRING_COUNT * ($STRING_COUNT + 1)) / 2 - $STRING_COUNT
  [System.Object]$Initializator_of_value_tuple = [System.ValueTuple[int64, string, string, int, int][]]::new($Termial)
  [System.Object]$Distances = [System.Collections.Generic.List[[System.ValueTuple[int64, string, string, int, int]]]]::new($Initializator_of_value_tuple)
  [System.Object]$Value_Tuple = [System.ValueTuple]::Create([int64]0, [string]'', [string]'', [int]0, [int]0)
  [int]$Distances_index = 0
  [int]$a_goal = $STRING_COUNT - 1
  for ($a = 0; $a -lt $a_goal; $a++) {
    [int]$X_a = $X[$a]
    [int]$Y_a = $Y[$a]
    [int]$Z_a = $Z[$a]
    [int]$B_start_index = $a + 1
    for ($b = $B_start_index; $b -lt $STRING_COUNT; $b++) {
      [int]$X_b = $X[$b]
      [int]$Y_b = $Y[$b]
      [int]$Z_b = $Z[$b]
      [int]$NUM1 = $X_a - $X_b
      [int]$NUM2 = $Y_a - $Y_b
      [int]$NUM3 = $Z_a - $Z_b
      $Value_Tuple.item1 = [int64]($NUM1 * $NUM1 + $NUM2 * $NUM2 + $NUM3 * $NUM3)
      $Value_Tuple.item2 = [string]"$X_a$Y_a$Z_a"
      $Value_Tuple.item3 = [string]"$X_b$Y_b$Z_b"
      $Value_Tuple.item4 = $X_a
      $Value_Tuple.item5 = $X_b
      $Distances[$Distances_index] = $Value_Tuple
      $Distances_index++
    }
  }
  
  $Distances.sort()
  [int]$GOAL_SELECTOR = $SELECTOR - 1
  return $Distances[0..$GOAL_SELECTOR]
}

function link_finder([System.Object]$SORTED_MAP, [int]$SELECTOR) {
  [hashtable]$INDEXES = @{}
  [hashtable]$Linked_items = @{}
  [int]$HT_INDEX = 0
  [bool]$iter = $true
  while ($INDEXES_count -ne $SELECTOR) {
    while ($iter -eq $true) {
      $iter = $false
      for ($a = 0; $a -lt $SELECTOR; $a++) {
        if ($INDEXES[$a]) { continue }
        
        [hashtable]$LINK = $Linked_items[$HT_INDEX]
        [string]$LINK_0 = $SORTED_MAP[$a].item2
        [string]$LINK_1 = $SORTED_MAP[$a].item3
        [int]$LINK_count = $LINK.count
        if ($LINK_count -eq 0) {
          [hashtable]$Linked_items[$HT_INDEX] = @{}
          $Linked_items[$HT_INDEX][$LINK_0] = $a + 1
          $Linked_items[$HT_INDEX][$LINK_1] = $a + 1
          $INDEXES[$a] = 1
          continue
        }

        if ($LINK[$LINK_0]) {
          if ($LINK[$LINK_1]) {
            $INDEXES[$a] = 1
            continue
          }
          
          $INDEXES[$a] = 1
          $Linked_items[$HT_INDEX][$LINK_1] = $a + 1
          $iter = $true
        }
        elseif ($LINK[$LINK_1]) {
          $INDEXES[$a] = 1
          $Linked_items[$HT_INDEX][$LINK_0] = $a + 1
          $iter = $true
        }
      }
    }
    
    $iter = $true
    $INDEXES_count = $INDEXES.keys.count
    $HT_INDEX++
  }

  [array]$SIZEs = @()
  foreach ($item in $Linked_items.GetEnumerator()) { $SIZEs += $item.Value.count }
  
  [int64]$SUM = 1
  foreach ($SIZE in ($SIZEs | Sort-Object -Descending | Select-Object -First 3)) { $SUM *= $SIZE }
  
  return $SUM
}

[array]$X, [array]$Y, [array]$Z, [int]$STRING_COUNT = file_parser
[System.Object]$SORTED_MAP = euclid_dist_solver -X $X -Y $Y -Z $Z -STRING_COUNT $STRING_COUNT -SELECTOR $SELECTOR
[int64]$SUM = link_finder -SORTED_MAP $SORTED_MAP -SELECTOR $SELECTOR

Write-Host "${GREEN}Sum is: $SUM, after multiply together the sizes of the three largest circuits of $SELECTOR junction boxes pairs which are closest together.${RESET}"
