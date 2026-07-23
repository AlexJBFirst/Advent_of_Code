Param(
  [Parameter(ValueFromPipeline, Position = 0)][String]$FILE_NAME
)

[string]$GREEN = "`e[32m"
[string]$RESET = "`e[0m"

function file_parser() {
  [string]$ABSOLUTE_PATH = Resolve-Path $FILE_NAME
  [array]$FILE_CONTENT = [System.IO.File]::ReadAllLines($ABSOLUTE_PATH)
  return $FILE_CONTENT
}

function beam_counter([array]$FILE_CONTENT) {
  [int]$FILE_CONTENT_count = $FILE_CONTENT.count
  [int]$String_length = $FILE_CONTENT[0].Length
  [int]$startIndex = $FILE_CONTENT[0].IndexOf('S')
  [array]$beams = [Int64[]]::new($String_length)
  $beams[$startIndex] = 1
  for ($a = 0; $a -lt $FILE_CONTENT_count; $a++) {
    [string]$FILE_CONTENT_a = $FILE_CONTENT[$a]
    if ($FILE_CONTENT_a.GetEnumerator() -notcontains '^') { continue }
    
    [hashtable]$newSplits = @{}
    for ($b = 0; $b -lt $String_length; $b++) {
      [char]$FILE_CONTENT_a_b = $FILE_CONTENT_a[$b]
      if ($FILE_CONTENT_a_b -ne '^') { continue }
      
      [Int64]$count = $beams[$b]
      $beams[$b] = 0
      [int]$left_index = $b - 1
      [int]$right_index = $b + 1
      $newSplits[$left_index] += $count
      $newSplits[$right_index] += $count
    }

    foreach ($key in $newSplits.Keys) { $beams[$key] += $newSplits[$key] }
  }

  return $beams
}

[array]$FILE_CONTENT = file_parser
[array]$beams = beam_counter -FILE_CONTENT $FILE_CONTENT
[Int64]$SUM = 0
foreach ($beam in $beams) { $SUM += $beam }

Write-Host "${GREEN}There are: $SUM different timelines for a single tachyon particle end up on.${RESET}"
