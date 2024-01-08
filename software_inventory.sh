#!/bin/bash

# List of software to check
software=("maya" "blender" "handbrake")

# Deletes the content in programs.txt
echo -n > "programs.txt"

# Creates programs.txt if it doesn't exist
touch "programs.txt"

# Gets the program name for each program in software list, adds it to programs.txt
for program in "${software[@]}"; do
    rpm -qa | grep -i "$program" >> "programs.txt" 
done

