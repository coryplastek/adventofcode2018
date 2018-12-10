# get letter count
function Get-LetterCount
{
    param($id)
    $letterCount = @{}
    0..($id.length-1) | % {
        $letter = $id[$_]
        if( $letterCount.ContainsKey($letter) )
        {
            $letterCount[$letter] += 1
        } else
        {
            $letterCount[$letter] = 1
        }
    }
    $letterCount
}

function Assert-LetterCount
{
    param($id, $count)
    $letterCount = Get-LetterCount $id
    if( $letterCount.Values -eq $count )
    {
        $true
    } else
    {
        $false
    }
}

# input
$boxIds = Get-Content -Path ..\input\day2.txt
$twoCount = 0
$threeCount = 0

foreach($id in $boxIds)
{
    if( Assert-LetterCount -id $id -count 2 )
    {
        $twoCount += 1
    }

    if( Assert-LetterCount -id $id -count 3 )
    {
        $threeCount += 1
    }
}
$checksum = $twoCount * $threeCount
Write-Host "Checksum: $checksum"

# part 2
$commonChars = @()
$differentChars = @()
$matchFound = $false
foreach( $id in $boxIds )
{
    foreach( $innerId in $boxIds )
    {
        0..($id.Length) | % {
            if( $id[$_] -eq $innerId[$_] )
            {
                # characters match
                $commonChars += $id[$_]
            } else
            {
                $differentChars += $innerId[$_]
            }
        }

        if( $differentChars.Count -eq 1 )
        {
            $matchFound = $true
            break
        } else {
            $commonChars = @()
            $differentChars = @()
        }
    }

    if( $matchFound )
    {
        break
    }
}
Write-Host "Common characters: $(-join $commonChars)"