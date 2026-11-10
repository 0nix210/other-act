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
    
    "Windows CE Platform Builder 3|0D"
    "Virtual PC for Mac 7|18"
    "Virtual PC for Mac 7|19"
    "Fable: The Lost Chapters|50"
    "Fable: The Lost Chapters|51"
    "Age of Mythology|50"
    "Age of Mythology|51"
    "Age of Empires III|50"
    "Age of Empires III|51"
    "Office Accounting 2006 / 2007 / 2008 / 2009|52"
    "Office Accounting 2006 / 2007 / 2008 / 2009|53"
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
