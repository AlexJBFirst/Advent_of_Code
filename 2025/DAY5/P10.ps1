Param(
	[Parameter(ValueFromPipeline, Position=0)][String]$FILE_NAME
)

[string]$GREEN="`e[32m"
[string]$RESET="`e[0m"
[string]$ABSOLUTE_PATH = Resolve-Path $FILE_NAME
[int64]$SUM = 0

function file_parser(){
  [array]$RANGEs=@()
  
  foreach($string in [System.IO.File]::ReadAllLines($ABSOLUTE_PATH)){
    if('' -eq $string){break}
    [int64]$MIN, [int64]$MAX = $string -split "-"
    $RANGEs += ,@($MIN,$MAX)
  }
  
  return $RANGEs
}

function merger(){
  [array]$MERGED = @()
  :main for($a=0;$a -lt $RANGEs.count;$a++){
    
    foreach($ITEM in $MERGED){
      if ($RANGEs[$a][0] -ge $ITEM[0] -and $RANGEs[$a][1] -le $ITEM[1]){continue main}
      elseif ($RANGEs[$a][0] -ge $ITEM[0] -and $RANGEs[$a][0] -le $ITEM[1]){
        $ITEM[1]=$RANGEs[$a][1]
        continue main
      }
    }

    $MERGED += ,$RANGEs[$a]
  }

  return $MERGED
}

[array]$RANGEs = file_parser
$RANGES = $RANGEs | Sort-Object -Property {$_[0][0]}
[array]$MERGED = merger


foreach($item in $merged){
  $SUM += $item[1] - $item[0] + 1
}

"${GREEN}There are $SUM available fresh ingredients${RESET}"
