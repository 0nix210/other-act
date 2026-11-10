#!/bin/bash
# umsktlist.bash
# Generates product keys per BINK ID using UMSKT
# Make sure that UMSKT binary is located in the same directory beside this script
#
# Usage:
#   bash umsktlist.bash                    # write to stdout (default 10 keys per BINK)
#   bash umsktlist.bash -o keys.txt        # write to file
#   bash umsktlist.bash -n 20              # 20 keys per BINK
#   bash umsktlist.bash -h                 # show usage
#
set -euo pipefail

UMSKT="./umskt"
OUTPUT=""            # empty = stdout
COUNT=10

# ---- Usage / help ------------------------------------------------------
usage() {
    cat <<EOF
Usage: $(basename "$0") [-o output_file] [-n count] [-h]

Generates product keys for every BINK ID listed in the script's
PRODUCTS table, using UMSKT.

Make sure that UMSKT binary is located in the same directory beside this script

Options:
  -o output_file   Write results to output_file instead of stdout.
  -n count         Number of keys to generate per BINK ID (default: 10).
  -h               Show this help message and exit.

Examples:
  $(basename "$0")
  $(basename "$0") -o keys.txt
  $(basename "$0") -n 20 -o keys.txt
EOF
}

# ---- Parse arguments ---------------------------------------------------
while getopts ":o:n:h" opt; do
    case "$opt" in
        o) OUTPUT="$OPTARG" ;;
        n)
            if ! [[ "$OPTARG" =~ ^[0-9]+$ ]] || (( OPTARG < 1 )); then
                echo "Error: -n requires a positive integer" >&2
                exit 1
            fi
            COUNT="$OPTARG"
            ;;
        h) usage; exit 0 ;;
        \?)
            echo "Error: unknown option -$OPTARG" >&2
            usage >&2
            exit 1
            ;;
        :)
            echo "Error: option -$OPTARG requires an argument" >&2
            usage >&2
            exit 1
            ;;
    esac
done
shift $((OPTIND - 1))

# Sanity check: ensure the umskt binary exists and is executable
if [[ ! -x "$UMSKT" ]]; then
    echo "Error: '$UMSKT' not found or not executable" >&2
    exit 1
fi

# If an output file was requested, truncate/create it.
# Otherwise, output goes to stdout.
if [[ -n "$OUTPUT" ]]; then
    > "$OUTPUT"
    exec 3>>"$OUTPUT"          # fd 3 = output sink
else
    exec 3>&1                  # fd 3 = stdout
fi

# Product table.
# Format: "Product Name|BINK_ID"
# Each BINK ID gets its own block of COUNT keys, so products that
# expose two BINK IDs (e.g. 20 and 21) produce two separate blocks.
PRODUCTS=(
    "Commerce Server 2002|0E"
    "Commerce Server 2002|0F"
    "Expression Web 2007 / Sharepoint Server 2007|76"
    "Expression Web 2007 / Sharepoint Server 2007|77"
    "Halo: Combat Evolved|50"
    "Halo: Combat Evolved|51"
    "Halo: Custom Edition|50"
    "Halo: Custom Edition|51"
    "Identity Lifecycle Manager 2007|78"
    "Identity Lifecycle Manager 2007|79"
    "Internet Security and Acceleration (ISA) Server 2004|06"
    "Internet Security and Acceleration (ISA) Server 2004|07"
    "Office 2000|04"
    "Office 2000|05"
    "Office 2003 Applications|6E"
    "Office 2003 Applications|6F"
    "Office 2003 Professional|72"
    "Office 2003 Professional|73"
    "Office 2003 Small Business|70"
    "Office 2003 Small Business|71"
    "Office 2003 Student and Teacher|70"
    "Office 2003 Student and Teacher|71"
    "Office 2007 Applications|7E"
    "Office 2007 Applications|7F"
    "Office 2007 Basic / Small Business|80"
    "Office 2007 Basic / Small Business|81"
    "Office 2007 Home & Student|88"
    "Office 2007 Home & Student|89"
    "Office 2007 Hybrid|84"
    "Office 2007 Hybrid|85"
    "Office 2007 Standard / Professional / Ultimate / Enterprise|82"
    "Office 2007 Standard / Professional / Ultimate / Enterprise|83"
    "Office Communicator 2007|0C"
    "Office Communicator 2007|0D"
    "Office XP|22"
    "Office XP|23"
    "Office XP Applications|20"
    "Office XP Applications|21"
    "Office for Mac 2004 / 2008|18"
    "Office for Mac 2004 / 2008|19"
    "PLUS! for Windows XP|08"
    "PLUS! for Windows XP|09"
    "Passport Manager|10"
    "Plus! Digital Media Edition for Windows XP|52"
    "Plus! Digital Media Edition for Windows XP|53"
    "Sharepoint Designer 2007|7C"
    "Sharepoint Designer 2007|7D"
    "Visual Studio .Net / .Net 2003|24"
    "Visual Studio .Net / .Net 2003|25"
    "Visual Studio 2005|52"
    "Visual Studio 2005|53"
    "Visual Studio 2008|78"
    "Visual Studio 2008|79"
    "Windows 2000 Professional|12"
    "Windows 2000 Professional|13"
    "Windows 2000 Server (all)|0A"
    "Windows 2000 Server (all)|13"
    "Windows 98 (all)|02"
    "Windows 98 (all)|03"
    "Windows CE .Net Platform Builder 4|00"
    "Windows CE .Net Platform Builder 4|01"
    "Windows CE .Net Platform Builder 5|0D"
    "Windows CE Platform Builder 3|00"
    "Windows CE Platform Builder 3|01"
    "Windows CE Platform Builder 3|0E"
    "Windows CE Platform Builder 3|0F"
    "Windows Embedded POSReady 2009|0D"
    "Windows Longhorn (6.0.3683.0 -> 6.0.4029.0)|40"
    "Windows Longhorn (6.0.3683.0 -> 6.0.4029.0)|41"
    "Windows Longhorn (6.0.4033.0)|54"
    "Windows Longhorn (6.0.4033.0)|55"
    "Windows Longhorn (6.0.4039.0 -> Pre PIDGENX)|74"
    "Windows Longhorn (6.0.4039.0 -> Pre PIDGENX)|75"
    "Windows ME|1C"
    "Windows ME|1D"
    "Windows Server 2003|54"
    "Windows Server 2003|55"
    "Windows Server 2003|58"
    "Windows Server 2003|59"
    "Windows Server 2003 64 Bit|68"
    "Windows Server 2003 64 Bit|69"
    "Windows Server 2003 64 Bit|6C"
    "Windows Server 2003 64 Bit|6D"
    "Windows Server 2003 64 Bit VLK|68"
    "Windows Server 2003 64 Bit VLK|69"
    "Windows Server 2003 64 Bit VLK|6C"
    "Windows Server 2003 64 Bit VLK|6D"
    "Windows Server 2003 VLK|5A"
    "Windows Server 2003 VLK|5B"
    "Windows XP Fundamentals for Legacy PCs|2E"
    "Windows XP Fundamentals for Legacy PCs|2F"
    "Windows XP Home|2A"
    "Windows XP Home|2B"
    "Windows XP Pro|2C"
    "Windows XP Pro|2D"
    "Windows XP Pro 64 Bit Edition|66"
    "Windows XP Pro 64 Bit Edition|67"
    "Windows XP Pro 64 Bit Edition VLK|64"
    "Windows XP Pro 64 Bit Edition VLK|65"
    "Windows XP Pro IA-64|2C"
    "Windows XP Pro IA-64|2D"
    "Windows XP Pro VLK|2E"
    "Windows XP Pro VLK|2F"
    "Windows XP Professional Evaluation|28"
    "Windows XP Professional Evaluation|29"
    "Windows XP Professional K|30"
    "Windows XP Professional K|31"
    "Windows XP Starter Edition|32"
    "Windows XP Starter Edition|33"
    "Works Suite 2003 and 2004|20"
    "Works Suite 2003 and 2004|21"
)

CURRENT=0
TOTAL_JOBS=${#PRODUCTS[@]}

# Progress messages always go to stderr so they never pollute stdout data
echo "Generating $COUNT keys per BINK ID ..." >&2
echo "" >&2

for entry in "${PRODUCTS[@]}"; do
    IFS='|' read -r name bink <<< "$entry"
    CURRENT=$((CURRENT + 1))

    # Header for this product block
    {
        echo "============================================================"
        echo "Product : $name"
        echo "BINK    : $bink"
        echo "============================================================"
    } >&3

    # Generate COUNT keys using only the BINK ID.
    # -N disables newlines so each key lands on its own line cleanly.
    # umskt writes to stdout; redirect into fd 3.
    if "$UMSKT" -n "$COUNT" -b "$bink" -N >&3 2>/dev/null; then
        STATUS="OK"
    else
        echo "(failed to generate keys for BINK $bink)" >&3
        STATUS="FAIL"
    fi

    echo "" >&3

    printf "[%3d/%3d] %-60s BINK %s ... %s\n" \
        "$CURRENT" "$TOTAL_JOBS" "$name" "$bink" "$STATUS" >&2
done

# Close fd 3 only if it points to a file (avoids closing stdout)
if [[ -n "$OUTPUT" ]]; then
    exec 3>&-
fi

echo "" >&2
if [[ -n "$OUTPUT" ]]; then
    echo "Done. Output written to: $OUTPUT" >&2
else
    echo "Done. Output written to stdout." >&2
fi
