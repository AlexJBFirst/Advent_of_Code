Param(
  [Parameter(ValueFromPipeline, Position = 0)][String]$FILE_NAME
)

[string]$GREEN = "`e[32m"
[string]$RESET = "`e[0m"
[string]$ABSOLUTE_PATH = Resolve-Path $FILE_NAME

function file_parser() {
  [string]$ABSOLUTE_PATH = Resolve-Path $FILE_NAME
  [array]$FILE_CONTENT = [System.IO.File]::ReadAllLines($ABSOLUTE_PATH)
  
  return $FILE_CONTENT
}

function beam_counter() {
  [int]$startIndex = $FILE_CONTENT[0].IndexOf('S')
  [array]$beams = [Int64[]]::new($FILE_CONTENT[0].Length)
  $beams[$startIndex] = 1

  for ($a = 0; $a -lt $FILE_CONTENT.count; $a++) {
    [hashtable]$newSplits = @{} 

    for ($b = 0; $b -lt $FILE_CONTENT[$a].Length; $b++) {
      if ($beams[$b] -eq 0 -or -not ($FILE_CONTENT[$a][$b] -eq '^')) { continue }
      [Int64]$count = $beams[$b]
      $beams[$b] = 0
      $newSplits[($b - 1)] += $count
      $newSplits[($b + 1)] += $count
    }

    foreach ($key in $newSplits.Keys) { $beams[$key] += $newSplits[$key] }
  }

  return $beams
}

[array]$FILE_CONTENT = file_parser
[array]$beams = beam_counter
[Int64]$SUM = 0

foreach ($beam in $beams) { $SUM += $beam }

Write-Host "${GREEN}There are: $SUM different timelines for a single tachyon particle end up on.${RESET}"
