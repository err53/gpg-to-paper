#!/bin/sh

verbose=false

# Get Arguments
while getopts "hv" opt; do
  case $opt in
    h)
      cat << EOF
usage: export_key [-h|-v]

Report bugs to: jasonhuang20035@gmail.com
EOF
      exit 1
      ;;
    v)
			echo "Outputting Verbosly..."
      verbose=true
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
  esac
done

# Check if neccessary utilities exist
command -v gpg >/dev/null 2>&1 || { echo >&2 "This program requires gpg but it's not installed.  Aborting."; exit 1; }
command -v paperkey >/dev/null 2>&1 || { echo >&2 "This program requires paperkey but it's not installed.  Aborting."; exit 1; }
command -v dmtxwrite >/dev/null 2>&1 || { echo >&2 "This program libdmtx (libdmtx-utils) but it's not installed.  Aborting."; exit 1; }

# Get user GPG key id
echo Please input GPG key id:
read KEY_ID

# Generates key-aa, key-ab, ...
if verbose=true
then
  echo "Exporting Secret Key $KEY_ID..."
fi
gpg --export-secret-key $KEY_ID | paperkey --output-type raw | split -b 1500 - $KEY_ID-

# Convert each of them to a PNG image
if verbose=true
then
  echo "Printing to PNG..."
fi
for K in $KEY_ID-*; do
    dmtxwrite -e 8 $K > $K.png
done
