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

# Adds an blank line to the programs.txt file
echo "" >> programs.txt

# Uses wc -l to get the number of lines in the programs.txt file aka num of programs
num_programs=$(wc -l < programs.txt)

# If programs.txt exists
if [ -e "programs.txt" ]; then
    line_count=0

    # Iterate over each item in the text file and run an information query for it
    # Loop breaks when the number of the line count is equal to the num programs number
    while IFS= read -r line && [ "$line_count" -lt "$num_programs" ]; do

        # Calls an information query on each program and adds its name, release and license information to the text file
        rpm -qi "$line" | awk '/^Name/ || /^Release/ || /^License/' >> programs.txt

        # Adds an empty line to text file
        echo "" >> programs.txt

        # Increment the line count
        ((line_count++))
    done < "programs.txt"
    
else
    echo "progams.txt not found"
fi

