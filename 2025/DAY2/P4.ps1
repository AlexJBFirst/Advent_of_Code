Param(
  [Parameter(ValueFromPipeline)][String]$FILE_NAME
)

[string]$GREEN = "`e[32m"
[string]$RESET = "`e[0m"
[string]$ABSOLUTE_PATH = Resolve-Path $FILE_NAME
[int64]$ID_COUNT = 0

foreach ($item in $([System.IO.File]::ReadAllLines($ABSOLUTE_PATH)) -split ',') {
  [int]$item_length = $item.Length
  if ($item_length -eq 0) { continue }

  [int64]$LOW, [int64]$HIGH = $item -split '-'
  for ($i = $LOW; $i -le $HIGH; $i++) {
    if ($i -match "^(.+)\1+$") { $ID_COUNT += $i }
  }
}

Write-Host "${GREEN}Invalid IDS SUM: $ID_COUNT${RESET}"