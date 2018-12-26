param(
    [Parameter(
        Mandatory = $true,
        Position  = 0
    )]
    [Int[]]
    $FrequencyChanges
) # end param

# part 1
$currentFrequency = 0
foreach( $frequencyChange in $frequencyChanges )
{
    $currentFrequency += $frequencyChange
}
Write-Host "Frequency sum: $currentFrequency"

# part 2
$foundFrequencies = [System.Collections.Generic.HashSet[int]]::new()
[void]$foundFrequencies.Add(0)
$currentFrequency = 0
$frequencyIndex = 0

do {
    $currentFrequency += $frequencyChanges[($frequencyIndex++ % $frequencyChanges.Count)] -as [int]
} while( $foundFrequencies.Add($currentFrequency) )
Write-Host "First duplicate frequency: $currentFrequency"