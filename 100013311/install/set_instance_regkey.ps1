$log="C:\asgard\logs\SessionMngr\set_instance_regkey.log"

$regkey='HKLM:\Software\NVIDIA Corporation\Global\Nimbus'
$udpath="C:\asgard\conf\secure_userdata.txt"

if (-not $(Test-Path $udpath))
{
  "${udpath} does not exist, this is a failure" >> $log
  return -1
}

$perfClass
try
{
  $perfClass=(get-content $udpath | convertfrom-json).SeatPoolName.split("-")[-1]
}
catch
{
  "Failed to parse perfClass" >> $log
  return -1
}

"Checking if ${regkey} exists" >> $log
if (-not $(Test-Path $regkey))
{
  "${regkey} does not exist, creating..." >> $log
  New-Item -Path $regkey
}
else
{
  "${regkey} exists" >> $log
}

"Setting perfClass in registry" >> $log
try
{
  New-ItemProperty -path $regkey -name 'SeatPerfClass' -value $perfClass -Force
  "Successfully set ${regkey}\SeatPerfClass to ${perfClass}" >> $log
}
catch
{
  "Failed to setup perfClass = ${perfClass} in registry" >> $log
  return -1
}

"Checking if DX12 WAR is needed" >> $log
try
{
  $required_it = @("ga10g_2.br20_large", "ga10g_1.br20_2xlarge")
  
  if ($required_it.Contains($perfClass))
  {
    & 'C:\Asgard\Tools\d3dreg.exe' 'HEAP_TIER2_COMPRESSION_SUPPORT=COMPRESS_ENTIRE_HEAP'
    if (0 -ne $LastExitCode)
    {
      "Failed to apply DX12 WAR." >> $log
      return -1
    }
    "DX12 WAR applied." >> $log
  }
  else
  {
    "WAR not required for ${perfClass}" >> $log
  }
}
catch
{
  $details = $_.Exception
  "Exception during DX12 WAR application ${details}." >> $log
  return -1
}