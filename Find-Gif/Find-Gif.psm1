<#
.Synopsis
   Finds a number of urls containing the gif you search for
.DESCRIPTION
   This uses tenor.com API to find the gif you are looking for, you have two parameters, one to search for the gif something like a keyword "excited" and the number of results to bring back whic will be a number something like 9
.EXAMPLE
   Find-Gif
.EXAMPLE
   Find-Gif
#>
function Find-Gif
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0,
                   HelpMessage="Just type a keyword for the type of gif you are looking for such as one of the following funny,excited,scared")]
        $SearchPhrase,
        [Parameter(HelpMessage="Use an integer value to bring back the number of URLS you want returned, each URL is a GIF of what you searched for")]
        [ValidatePattern("[0-9]")]
        [int]
        $NumberOfResults = 8
    )

    Begin
    {
    Write-Host -ForegroundColor Green "Finding Gifs related to $SearchPhrase please wait for results."
    }
    Process
    {
    try
    {
     ((Invoke-WebRequest -Uri "https://g.tenor.com/v1/search?q=$SearchPhrase&key=LIVDSRZULELA&limit=$NumberOfResults" -ErrorAction Stop | Select-Object content).content | ConvertFrom-Json).Results | select -ExpandProperty url -OutVariable urls 
     foreach ($url in $urls) 
        {
     Write-Host -ForegroundColor Green "Actual link to just the Gif file"
     (Invoke-WebRequest "$url" | select images).Images | Where-Object {$_.src -match "c.tenor.com"} | Select -ExpandProperty src
        }
    }
    catch
    {
        $bad = $_
        Write-Warning "Whoops something went wrong $bad"
    }
    }
    End
    {
    Write-Host -ForegroundColor Green "Enjoy your Gifs"
    }
}