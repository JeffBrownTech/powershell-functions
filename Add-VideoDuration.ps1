function Add-VideoDuration {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [psobject[]]
        $File
    )

    # Reference: http://poshdb.com/repository/powershell-get-video-duration/

    BEGIN {
        $lengthColumn = 27
        $videoExtensions = @(".mp4", ".m4p", ".m4v", ".mov", ".avi", ".flv", ".wmv", ".mpg", ".mpeg", ".svi")
    }

    PROCESS {
        foreach ($item in $File) {
            try {
                $fullItem = Get-Item -Path $item.FullName -ErrorAction STOP
            }
            catch [System.Management.Automation.ItemNotFoundException] {
                Write-Warning -Message "$item is not a valid path or file."
                continue
            }
            catch [System.Management.Automation.ParameterBindingException] {
                Write-Warning -Message "$item is not a full path and cannot bind to -Path in Get-Item."
            }
            catch {
                Write-Warning -Message $Error[0]
            }

            # Verify file is a valid video extension and is not a directory/folder
            if ($videoExtensions.Contains($fullItem.Extension) -eq $true -and $fullItem.Mode -notlike "d*") {
                $objShell = New-Object -ComObject Shell.Application
                $objFolder = $objShell.Namespace($fullItem.DirectoryName)
                $objFile = $objFolder.ParseName($fullItem.Name)
                $duration = $objFolder.GetDetailsOf($objFile, $lengthColumn)
    
                Add-Member -InputObject $fullItem -MemberType NoteProperty -Name Duration -Value $duration
    
                Write-Output $fullItem
            } # End of if statement
        } # End of foreach ($item in $File)
    } # End of PROCESS
} # End of Get-VideoLength