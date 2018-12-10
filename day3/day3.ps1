$claims = Get-Content -Path .\input.txt

function Get-ClaimInfo
{
    param($claim)

    # each claim in represented in text in the following format:
    # #c @ x,y: w(x)h
    # e.g. #1 @ 1,3: 4x4
    # where c is the claim number
    # and   x is the start of the claim, in x inches from the left edge
    # and   y is the start of the claim, in y inches from the top edge
    # and   w is the width of the claim, in inches wide
    # and   h is the height of the claim, in inches tall
    $c = $claim.Substring(1) -replace '\s','' -split '[@,:x]'

    [pscustomobject]@{
        'id' = $c[0] -as [int]
        'x'  = $c[1] -as [int]
        'y'  = $c[2] -as [int]
        'w'  = $c[3] -as [int]
        'h'  = $c[4] -as [int]
    }
}

# we could create a multi-dimensional array (x,y)
# and then foreach claim, find the start of the claim coordinates
# and then iterate over each column in that row and add 1 to the column value
# and then iterate over each row (for the length of the claim) and do the same
$fabric = New-Object 'object[,]' 1000,1000
foreach( $claim in $claims )
{
    $claimInfo = Get-ClaimInfo -claim $claim
    $startX = $claimInfo.x
    $startY = $claimInfo.y
    for( $x = $claimInfo.x; $x -lt $startX + $claimInfo.w; $x++ )
    {
        for( $y = $claimInfo.y; $y -lt $startY + $claimInfo.h; $y++ )
        {
            $fabric[$x,$y] += 1
        }
    }
}

# to determine the overlap of all the claims, count how many values are more than 1?
$overlapInches = 0
foreach( $f in $fabric )
{
    if( $f -gt 1 )
    {
        $overlapInches += 1
    }
}
Write-Host "Overlapping claim inches: $overlapInches"

# part 2
# to figure out which claims do not overlap, iterate over the claims again,
# and instead of adding 1 to the fabric x,y value, keep track of if the
# x,y value is more than 1. if the value is not more than 1 for the entire claim
# then the claim does not overlap
$nonOverlapClaim = 0
foreach( $claim in $claims )
{
    $overlapDetected = $false
    $claimInfo = Get-ClaimInfo -claim $claim
    $startX = $claimInfo.x
    $startY = $claimInfo.y
    for( $x = $claimInfo.x; $x -lt $startX + $claimInfo.w; $x++ )
    {
        for( $y = $claimInfo.y; $y -lt $startY + $claimInfo.h; $y++ )
        {
            if( $fabric[$x,$y] -gt 1 )
            {
                $overlapDetected = $true
            } else
            {
                $overlapDetected = $false -or $overlapDetected
            }
        }
    }

    # if overlap is detected for this claim, go to the next claim
    # if no overlap is detected, we found the claim we're looking for
    if( -not $overlapDetected )
    {
        $nonOverlapClaim = $claimInfo.id
        break
    }
}
Write-Host "Non-overlapping claim id: $nonOverlapClaim"