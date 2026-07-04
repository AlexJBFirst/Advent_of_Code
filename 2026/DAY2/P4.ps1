Param(
	[Parameter(ValueFromPipeline)][String]$FILE_NAME
)

$ABSOLUTE_PATH = Resolve-Path $FILE_NAME
[int64]$ID_COUNT=0

foreach ($item in $([System.IO.File]::ReadAllLines($ABSOLUTE_PATH)) -split ','){
  if ($item.Length -eq 0){continue}

  [int64]$LOW, [int64]$HIGH = $item -split '-'

  for ($i = $LOW; $i -le $HIGH; $i++) {
    if ($i -match "^(.+)\1+$"){
      $ID_COUNT+=$i
    }
  }

}

"`e[32mInvalid IDS SUM: $ID_COUNT`e[0m"