Param(
  [Parameter(ValueFromPipeline, Position = 0)][String]$FILE_NAME
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

function euclid_dist_solver([array]$X, [array]$Y, [array]$Z, [int]$STRING_COUNT) {
  [int64]$Termial = ($STRING_COUNT * ($STRING_COUNT + 1)) / 2 - $STRING_COUNT
  [System.Object]$Initializator_of_value_tuple = [System.ValueTuple[int64, string, string, int, int][]]::new($Termial)
  [System.Object]$Distances = [System.Collections.Generic.List[[System.ValueTuple[int64, string, string, int, int]]]]::new($Initializator_of_value_tuple)
  [System.Object]$Value_Tuple = [System.ValueTuple]::Create([int64]0,[string]'',[string]'',[int]0,[int]0)
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
  return $Distances, $Termial
}

function link_finder([System.Object]$SORTED_MAP, [int]$STRING_COUNT, [int]$SORTED_MAP_count) {
  [hashtable]$LINKED_CIRCUIT = @{}
  [hashtable]$INDEXES = @{}
  [System.Object]$LINK = $SORTED_MAP[0]
  [int]$LINKS=2
  $LINKED_CIRCUIT[$LINK.item2] = 1
  $LINKED_CIRCUIT[$LINK.item3] = 1
  while ($LINKS -ne $STRING_COUNT) {
    for ($a = 1; $a -lt $SORTED_MAP_count; $a++) {
      if ($INDEXES[$a]) { continue }
      
      [string]$LINK_0 = $SORTED_MAP[$a].item2
      [string]$LINK_1 = $SORTED_MAP[$a].item3
      if ($LINKED_CIRCUIT[$LINK_0]) {
        if ($LINKED_CIRCUIT[$LINK_1]) {
          $INDEXES[$a] = $a
          continue
        }
        
        $LINKED_CIRCUIT[$LINK_1] = 1
        $INDEXES[$a] = $a
        break
      } elseif ($LINKED_CIRCUIT[$LINK_1]) {
        $LINKED_CIRCUIT[$LINK_0] = 1
        $INDEXES[$a] = $a
        break
      }
    }
    
    $LINKS++
  }
  
  return $SORTED_MAP[$a].item4, $SORTED_MAP[$a].item5
}

[array]$X, [array]$Y, [array]$Z, [int]$STRING_COUNT = file_parser
[System.Object]$SORTED_MAP, [int]$SORTED_MAP_count = euclid_dist_solver -X $X -Y $Y -Z $Z -STRING_COUNT $STRING_COUNT
[int]$X_a, [int]$X_b = link_finder -SORTED_MAP $SORTED_MAP -STRING_COUNT $STRING_COUNT -SORTED_MAP_count $SORTED_MAP_count
[int64]$SUM = $X_a * $X_b

Write-Host "${GREEN}Multiplication of X coordinates results in: $SUM.${RESET}"
