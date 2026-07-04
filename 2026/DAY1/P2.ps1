Param(
  [Parameter(ValueFromPipeline, Position=0)][String]$FILE_NAME,
  [Parameter(ValueFromPipeline, Position=1)][bool]$DEBUG_FLAG=$FALSE
)

#DEBUG function take long time to process, so if comented all DEBUG function calls this code will be much faster

[string]$ABSOLUTE_PATH = Resolve-Path $FILE_NAME
[int]$DIAL=50
[int]$COUNT=0

function DEBUG {
  param (
    $DEBUG_STRING
  )

  if ($DEBUG_FLAG){
    Write-Host $DEBUG_STRING -ForegroundColor Red
  }
}

foreach ($lines in [System.IO.File]::ReadAllLines($ABSOLUTE_PATH)){
  [string]$DIRECTION=$lines[0]
  [int]$NUMBER=$lines[1..($lines.Length - 1)] -join ""
  if ($DIRECTION -eq 'L') {
    DEBUG "DIAL: $DIAL - $NUMBER"
    
    if ($DIAL -eq 0){
      $DIAL+=100
    }
    
    $DIAL-=$NUMBER
    
    while ($DIAL -lt 0){
      $COUNT++
      DEBUG "Count is: $COUNT ___ DIAL: $DIAL"
      $DIAL+=100
    }
    
    if ($DIAL -eq 0){
        $COUNT++
        DEBUG "Count is: $COUNT"
    }
    
    DEBUG "DIAL: $DIAL"
  } else {
    DEBUG "DIAL: $DIAL + $NUMBER"
    $DIAL+=$NUMBER
    
    while ($DIAL -ge 100 ){
      DEBUG "DIAL: $DIAL"
      $DIAL-=100
      $COUNT++
    }
    
    DEBUG "DIAL: $DIAL"
  }
}

"`e[32mFINAL Count is: $COUNT`e[0m"