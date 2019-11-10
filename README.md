# powershell-functions
Collection of random PowerShell functions

## Add-VideoDuration
This function adds a Duration property to video files so it can be viewed in the PowerShell console. The duration of video files is not exposed when using Get-Item, so this adds to it.
Currenly only works when sending files to it using Get-Item, for example:

```
Get-Item -Path C:\videos | Add-VideoDuration | Select-Object Name, Duration

Name                       Duration
----                       --------
video1.mp4                 00:04:33
video2.mp4                 00:04:18
video3.mp4                 00:02:23
```