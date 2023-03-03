#!/bin/bash
## Author: wadje44
## Version: v0.0.1
## Description: test script with params

option_mode=false
args=()

for arg in "$@"; do
  if [[ $arg == -* ]]; then
    if [[ $arg == "-m" ]]; then
      option_mode=true
      value=1
    else
      echo "Invalid option: $arg" >&2
      exit 1
    fi
  else
    args+=("$arg")
  fi
done

if [ ${#args[@]} -gt 0 ]; then
  echo "Hey, from file just-an-echo!!!!"
  echo "first arg is ${args[0]}"
fi

if [ $option_mode = true ]; then
  echo "Running in option mode-------------------------$value"
  # option implementation
fi
