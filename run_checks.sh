#!/usr/bin/bash

OVERALL="PASS"

report_file="drc.rpt"
search_string="No DRC violations were found"


# Check if the file exists
if [ -f "$report_file" ]; then
  # Use grep to search for the string.
  # The -q (quiet) option suppresses output and
  # grep exits with a 0 status if the string is found.
  if grep -qF "$search_string" "$report_file"; then
    echo "PASS: Found the string '$search_string' in $report_file."
  else
    echo "FAIL: The string '$search_string' was NOT found in $report_file."
    OVERALL="FAIL"
  fi
else
  echo "FAIL: File $report_file not found."
  OVERALL="FAIL"
fi

report_file="connect.rpt"
search_string="Found no problems or warnings."

# Check if the file exists
if [ -f "$report_file" ]; then
  # Use grep to search for the string.
  # The -q (quiet) option suppresses output and
  # grep exits with a 0 status if the string is found.
  if grep -qF "$search_string" "$report_file"; then
    echo "PASS: Found the string '$search_string' in $report_file."
  else
    echo "FAIL: The string '$search_string' was NOT found in $report_file."
    OVERALL="FAIL"
  fi
else
  echo "FAIL: File $report_file not found."
  OVERALL="FAIL"
fi

SETUP_WNS=$(awk '/Setup mode/,/Hold mode/ { if (/WNS \(ns\):/) { match($0, /([+-]?[0-9]+\.?[0-9]*)/, a); print a[1]; exit } }' timing_report/picorv32.summary)

HOLD_WNS=$(awk '/Hold mode/,/^$/ { if (/WNS \(ns\):/) { match($0, /([+-]?[0-9]+\.?[0-9]*)/, a); print a[1]; exit } }' timing_report/picorv32.summary)

if (( $(echo "$SETUP_WNS >= 0" | bc -l) )); then
  echo "PASS:  Setup Checks"
else
  echo "FAIL:  Setup Checks" 
  OVERALL="FAIL"
fi

if (( $(echo "$HOLD_WNS >= 0" | bc -l) )); then
  echo "PASS:  Hold Checks"
else
  echo "FAIL:  Hold Checks" 
  OVERALL="FAIL"
fi


echo "Overall: $OVERALL"

