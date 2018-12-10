$frequencyChanges = Get-Content ..\input\day1.txt

# part 1
$currentFrequency = 0
foreach( $frequencyChange in $frequencyChanges )
{
    $currentFrequency += $frequencyChange
}
Write-Host "Frequency sum: $currentFrequency"

# part 2
$foundFrequencies = New-Object -TypeName System.Collections.Hashtable

$currentFrequency = 0
$duplicateFrequencyFound = $false
$frequencyIndex = 0

while( -not $duplicateFrequencyFound )
{
    $currentFrequency += $frequencyChanges[($frequencyIndex % $frequencyChanges.Count)]

    if( $foundFrequencies.ContainsKey($currentFrequency) )
    {
        # dupe found!
        $duplicateFrequencyFound = $true
        Write-Host "First duplicate frequency: $currentFrequency"
    } else
    {
        $foundFrequencies.Add($currentFrequency, 0)
    }
    $frequencyIndex++
}