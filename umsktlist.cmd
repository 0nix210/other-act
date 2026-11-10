@echo off
REM umsktlist.bat - Win98+ compatible
REM To add a product, append two lines named PROD_XX_NAME containing name
REM (can be spaced) and PROD_XX_BINK for BINK ID, then bump TOTAL.
REM Example:
REM set PROD_112_NAME=AAA AAA AAA
REM set PROD_112_BINK=77
REM set PROD_113_NAME=AAA AAA AAA
REM set PROD_113_BINK=79
REM set TOTAL=113
setlocal

set "UMSKT=umskt.exe"
set "OUTPUT="
set "COUNT=10"

REM ---- Parse arguments --------------------------------------------------
:parse
if "%~1"=="" goto parse_done
if /i "%~1"=="-h" goto usage
if /i "%~1"=="-o" goto opt_o
if /i "%~1"=="-n" goto opt_n
echo Error: unknown option "%~1" 1>&2
goto usage_err

:opt_o
shift
if "%~1"=="" ( echo Error: -o requires an argument 1>&2 & goto usage_err )
set "OUTPUT=%~1"
shift
goto parse

:opt_n
shift
if "%~1"=="" ( echo Error: -n requires an argument 1>&2 & goto usage_err )
set "COUNT=%~1"
shift
goto parse

:parse_done

REM ---- Sanity check -----------------------------------------------------
if not exist "%UMSKT%" (
    echo Error: UMSKT binary not found: %UMSKT% 1>&2
    exit /b 1
)

REM ---- Output sink: truncate file if -o given ---------------------------
if not "%OUTPUT%"=="" if exist "%OUTPUT%" del "%OUTPUT%"

REM ---- Product table: NAME and BINK stored separately ------------------
set PROD_01_NAME=Commerce Server 2002
set PROD_01_BINK=0E
set PROD_02_NAME=Commerce Server 2002
set PROD_02_BINK=0F
set PROD_03_NAME=Expression Web 2007 / Sharepoint Server 2007
set PROD_03_BINK=76
set PROD_04_NAME=Expression Web 2007 / Sharepoint Server 2007
set PROD_04_BINK=77
set PROD_05_NAME=Halo: Combat Evolved
set PROD_05_BINK=50
set PROD_06_NAME=Halo: Combat Evolved
set PROD_06_BINK=51
set PROD_07_NAME=Halo: Custom Edition
set PROD_07_BINK=50
set PROD_08_NAME=Halo: Custom Edition
set PROD_08_BINK=51
set PROD_09_NAME=Identity Lifecycle Manager 2007
set PROD_09_BINK=78
set PROD_10_NAME=Identity Lifecycle Manager 2007
set PROD_10_BINK=79
set PROD_11_NAME=Internet Security and Acceleration (ISA) Server 2004
set PROD_11_BINK=06
set PROD_12_NAME=Internet Security and Acceleration (ISA) Server 2004
set PROD_12_BINK=07
set PROD_13_NAME=Office 2000
set PROD_13_BINK=04
set PROD_14_NAME=Office 2000
set PROD_14_BINK=05
set PROD_15_NAME=Office 2003 Applications
set PROD_15_BINK=6E
set PROD_16_NAME=Office 2003 Applications
set PROD_16_BINK=6F
set PROD_17_NAME=Office 2003 Professional
set PROD_17_BINK=72
set PROD_18_NAME=Office 2003 Professional
set PROD_18_BINK=73
set PROD_19_NAME=Office 2003 Small Business
set PROD_19_BINK=70
set PROD_20_NAME=Office 2003 Small Business
set PROD_20_BINK=71
set PROD_21_NAME=Office 2003 Student and Teacher
set PROD_21_BINK=70
set PROD_22_NAME=Office 2003 Student and Teacher
set PROD_22_BINK=71
set PROD_23_NAME=Office 2007 Applications
set PROD_23_BINK=7E
set PROD_24_NAME=Office 2007 Applications
set PROD_24_BINK=7F
set PROD_25_NAME=Office 2007 Basic / Small Business
set PROD_25_BINK=80
set PROD_26_NAME=Office 2007 Basic / Small Business
set PROD_26_BINK=81
set PROD_27_NAME=Office 2007 Home ^& Student
set PROD_27_BINK=88
set PROD_28_NAME=Office 2007 Home ^& Student
set PROD_28_BINK=89
set PROD_29_NAME=Office 2007 Hybrid
set PROD_29_BINK=84
set PROD_30_NAME=Office 2007 Hybrid
set PROD_30_BINK=85
set PROD_31_NAME=Office 2007 Standard / Professional / Ultimate / Enterprise
set PROD_31_BINK=82
set PROD_32_NAME=Office 2007 Standard / Professional / Ultimate / Enterprise
set PROD_32_BINK=83
set PROD_33_NAME=Office Communicator 2007
set PROD_33_BINK=0C
set PROD_34_NAME=Office Communicator 2007
set PROD_34_BINK=0D
set PROD_35_NAME=Office XP
set PROD_35_BINK=22
set PROD_36_NAME=Office XP
set PROD_36_BINK=23
set PROD_37_NAME=Office XP Applications
set PROD_37_BINK=20
set PROD_38_NAME=Office XP Applications
set PROD_38_BINK=21
set PROD_39_NAME=Office for Mac 2004 / 2008
set PROD_39_BINK=18
set PROD_40_NAME=Office for Mac 2004 / 2008
set PROD_40_BINK=19
set PROD_41_NAME=PLUS! for Windows XP
set PROD_41_BINK=08
set PROD_42_NAME=PLUS! for Windows XP
set PROD_42_BINK=09
set PROD_43_NAME=Passport Manager
set PROD_43_BINK=10
set PROD_44_NAME=Plus! Digital Media Edition for Windows XP
set PROD_44_BINK=52
set PROD_45_NAME=Plus! Digital Media Edition for Windows XP
set PROD_45_BINK=53
set PROD_46_NAME=Sharepoint Designer 2007
set PROD_46_BINK=7C
set PROD_47_NAME=Sharepoint Designer 2007
set PROD_47_BINK=7D
set PROD_48_NAME=Visual Studio .Net / .Net 2003
set PROD_48_BINK=24
set PROD_49_NAME=Visual Studio .Net / .Net 2003
set PROD_49_BINK=25
set PROD_50_NAME=Visual Studio 2005
set PROD_50_BINK=52
set PROD_51_NAME=Visual Studio 2005
set PROD_51_BINK=53
set PROD_52_NAME=Visual Studio 2008
set PROD_52_BINK=78
set PROD_53_NAME=Visual Studio 2008
set PROD_53_BINK=79
set PROD_54_NAME=Windows 2000 Professional
set PROD_54_BINK=12
set PROD_55_NAME=Windows 2000 Professional
set PROD_55_BINK=13
set PROD_56_NAME=Windows 2000 Server (all)
set PROD_56_BINK=0A
set PROD_57_NAME=Windows 2000 Server (all)
set PROD_57_BINK=13
set PROD_58_NAME=Windows 98 (all)
set PROD_58_BINK=02
set PROD_59_NAME=Windows 98 (all)
set PROD_59_BINK=03
set PROD_60_NAME=Windows CE .Net Platform Builder 4
set PROD_60_BINK=00
set PROD_61_NAME=Windows CE .Net Platform Builder 4
set PROD_61_BINK=01
set PROD_62_NAME=Windows CE .Net Platform Builder 5
set PROD_62_BINK=0D
set PROD_63_NAME=Windows CE Platform Builder 3
set PROD_63_BINK=00
set PROD_64_NAME=Windows CE Platform Builder 3
set PROD_64_BINK=01
set PROD_65_NAME=Windows CE Platform Builder 3
set PROD_65_BINK=0E
set PROD_66_NAME=Windows CE Platform Builder 3
set PROD_66_BINK=0F
set PROD_67_NAME=Windows Embedded POSReady 2009
set PROD_67_BINK=0D
set PROD_68_NAME=Windows Longhorn (6.0.3683.0 -^> 6.0.4029.0)
set PROD_68_BINK=40
set PROD_69_NAME=Windows Longhorn (6.0.3683.0 -^> 6.0.4029.0)
set PROD_69_BINK=41
set PROD_70_NAME=Windows Longhorn (6.0.4033.0)
set PROD_70_BINK=54
set PROD_71_NAME=Windows Longhorn (6.0.4033.0)
set PROD_71_BINK=55
set PROD_72_NAME=Windows Longhorn (6.0.4039.0 -^> Pre PIDGENX)
set PROD_72_BINK=74
set PROD_73_NAME=Windows Longhorn (6.0.4039.0 -^> Pre PIDGENX)
set PROD_73_BINK=75
set PROD_74_NAME=Windows ME
set PROD_74_BINK=1C
set PROD_75_NAME=Windows ME
set PROD_75_BINK=1D
set PROD_76_NAME=Windows Server 2003
set PROD_76_BINK=54
set PROD_77_NAME=Windows Server 2003
set PROD_77_BINK=55
set PROD_78_NAME=Windows Server 2003
set PROD_78_BINK=58
set PROD_79_NAME=Windows Server 2003
set PROD_79_BINK=59
set PROD_80_NAME=Windows Server 2003 64 Bit
set PROD_80_BINK=68
set PROD_81_NAME=Windows Server 2003 64 Bit
set PROD_81_BINK=69
set PROD_82_NAME=Windows Server 2003 64 Bit
set PROD_82_BINK=6C
set PROD_83_NAME=Windows Server 2003 64 Bit
set PROD_83_BINK=6D
set PROD_84_NAME=Windows Server 2003 64 Bit VLK
set PROD_84_BINK=68
set PROD_85_NAME=Windows Server 2003 64 Bit VLK
set PROD_85_BINK=69
set PROD_86_NAME=Windows Server 2003 64 Bit VLK
set PROD_86_BINK=6C
set PROD_87_NAME=Windows Server 2003 64 Bit VLK
set PROD_87_BINK=6D
set PROD_88_NAME=Windows Server 2003 VLK
set PROD_88_BINK=5A
set PROD_89_NAME=Windows Server 2003 VLK
set PROD_89_BINK=5B
set PROD_90_NAME=Windows XP Fundamentals for Legacy PCs
set PROD_90_BINK=2E
set PROD_91_NAME=Windows XP Fundamentals for Legacy PCs
set PROD_91_BINK=2F
set PROD_92_NAME=Windows XP Home
set PROD_92_BINK=2A
set PROD_93_NAME=Windows XP Home
set PROD_93_BINK=2B
set PROD_94_NAME=Windows XP Pro
set PROD_94_BINK=2C
set PROD_95_NAME=Windows XP Pro
set PROD_95_BINK=2D
set PROD_96_NAME=Windows XP Pro 64 Bit Edition
set PROD_96_BINK=66
set PROD_97_NAME=Windows XP Pro 64 Bit Edition
set PROD_97_BINK=67
set PROD_98_NAME=Windows XP Pro 64 Bit Edition VLK
set PROD_98_BINK=64
set PROD_99_NAME=Windows XP Pro 64 Bit Edition VLK
set PROD_99_BINK=65
set PROD_100_NAME=Windows XP Pro IA-64
set PROD_100_BINK=2C
set PROD_101_NAME=Windows XP Pro IA-64
set PROD_101_BINK=2D
set PROD_102_NAME=Windows XP Pro VLK
set PROD_102_BINK=2E
set PROD_103_NAME=Windows XP Pro VLK
set PROD_103_BINK=2F
set PROD_104_NAME=Windows XP Professional Evaluation
set PROD_104_BINK=28
set PROD_105_NAME=Windows XP Professional Evaluation
set PROD_105_BINK=29
set PROD_106_NAME=Windows XP Professional K
set PROD_106_BINK=30
set PROD_107_NAME=Windows XP Professional K
set PROD_107_BINK=31
set PROD_108_NAME=Windows XP Starter Edition
set PROD_108_BINK=32
set PROD_109_NAME=Windows XP Starter Edition
set PROD_109_BINK=33
set PROD_110_NAME=Works Suite 2003 and 2004
set PROD_110_BINK=20
set PROD_111_NAME=Works Suite 2003 and 2004
set PROD_111_BINK=21
set PROD_112_NAME=Windows CE Platform Builder 3
set PROD_112_BINK=0D
set PROD_113_NAME=Virtual PC for Mac 7
set PROD_113_BINK=18
set PROD_114_NAME=Virtual PC for Mac 7
set PROD_114_BINK=19
set PROD_115_NAME=Fable: The Lost Chapters
set PROD_115_BINK=50
set PROD_116_NAME=Fable: The Lost Chapters
set PROD_116_BINK=51
set PROD_117_NAME=Age of Mythology
set PROD_117_BINK=50
set PROD_118_NAME=Age of Mythology
set PROD_118_BINK=51
set PROD_119_NAME=Age of Empires III
set PROD_119_BINK=50
set PROD_120_NAME=Age of Empires III
set PROD_120_BINK=51
set PROD_121_NAME=Office Accounting 2006 / 2007 / 2008 / 2009
set PROD_121_BINK=52
set PROD_122_NAME=Office Accounting 2006 / 2007 / 2008 / 2009
set PROD_122_BINK=53

set TOTAL=122

echo Generating %COUNT% keys per BINK ID ... 1>&2
echo. 1>&2

set /a IDX=0

REM ---- Main loop --------------------------------------------------------
:next
set /a IDX=IDX+1
if %IDX% GTR %TOTAL% goto finished

REM Correct padding to match PROD_01..09 / PROD_10..99 / PROD_100+
set NUM=%IDX%
if %IDX% LSS 10 set NUM=0%IDX%

REM Indirect expansion via CALL SET (works on Win98 command.com)
call set "NAME=%%PROD_%NUM%_NAME%%"
call set "BINK=%%PROD_%NUM%_BINK%%"

REM Guard: skip if either variable is undefined (prevents -b with empty arg)
if "%NAME%"=="" (
    echo [SKIP] IDX %IDX% - PROD_%NUM%_NAME is missing 1>&2
    goto next
)
if "%BINK%"=="" (
    echo [SKIP] IDX %IDX% - PROD_%NUM%_BINK is missing 1>&2
    goto next
)

REM ---- Branch: stdout vs file (goto-based, no if-block on 98) ----------
if "%OUTPUT%"=="" goto write_stdout

REM ----- Write to file -----
echo ============================================================>>"%OUTPUT%"
echo Product : %NAME%>>"%OUTPUT%"
echo BINK    : %BINK%>>"%OUTPUT%"
echo ============================================================>>"%OUTPUT%"
"%UMSKT%" -n %COUNT% -b %BINK% -N >>"%OUTPUT%"
if errorlevel 1 echo (failed to generate keys for BINK %BINK%)>>"%OUTPUT%"
echo.>>"%OUTPUT%"
goto progress

REM ----- Write to stdout -----
:write_stdout
echo ============================================================
echo Product : %NAME%
echo BINK    : %BINK%
echo ============================================================
"%UMSKT%" -n %COUNT% -b %BINK% -N
if errorlevel 1 echo (failed to generate keys for BINK %BINK%)
echo.

REM ----- Progress line -----
:progress
if errorlevel 1 (
    echo [%IDX%/%TOTAL%] %NAME%  BINK %BINK% ... FAIL 1>&2
) else (
    echo [%IDX%/%TOTAL%] %NAME%  BINK %BINK% ... OK 1>&2
)
goto next

REM ---- Finished ---------------------------------------------------------
:finished
echo. 1>&2
if "%OUTPUT%"=="" (
    echo Done. Output written to stdout. 1>&2
) else (
    echo Done. Output written to: %OUTPUT% 1>&2
)
endlocal
exit /b 0

REM ---- Usage ------------------------------------------------------------
:usage
echo Usage: %~nx0 [-o output_file] [-n count] [-h]
echo.
echo Generates product keys for every BINK ID listed in the script.
echo.
echo Options:
echo   -o output_file   Write results to output_file instead of stdout.
echo   -n count         Number of keys per BINK ID (default: 10).
echo   -h               Show this help and exit.
endlocal
exit /b 0

:usage_err
echo Usage: %~nx0 [-o output_file] [-n count] [-h] 1>&2
endlocal
exit /b 1
