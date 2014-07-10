set pkgid="odvision"
set mydate=%date:~6,4%%date:~3,2%%date:~0,2%
"c:\Program Files\7-Zip\7z.exe" a -ttar -so %pkgid%.tar usr var |"c:\Program Files\7-Zip\7z.exe" a  -si %pkgid%-%mydate%.tar.gz 