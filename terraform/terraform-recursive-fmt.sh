#!/bin/bash

# Script to recursively format Terraform files in the 
# current directory and below.

find . -type f -name '*.tf' | while read -r file; do
  terraform fmt "$file"
done
