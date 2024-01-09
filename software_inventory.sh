#!/bin/bash

# List of software to check
software=("maya" "blender" "firefox")

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

        # Calls an information query on each program and adds its information to the text file
        rpm -qi "$line" | awk '/^Name/ || /^Version/ || /^Release/ || /^License/' >> programs.txt

        # Adds an empty line to text file
        echo "" >> programs.txt

        # Increment the line count
        ((line_count++))
    done < "programs.txt"

else
    echo "progams.txt not found"
fi

# An array that takes the program name from the name field in txt file and adds its name to array as string
program_names=$(awk '/Name/ {print $3}' programs.txt)

# Loop through each program name (dont need [@] because its string not individual item)
for program in $program_names; do

    # Trim leading and trailing whitespaces
    program=$(echo "$program" | awk '{$1=$1;print}')

    # Run dnf list for each program
    dnf list "$program" | awk 'NR > 3 {print}' >> programs.txt

    # Adds an empty line to text file
    echo "" >> programs.txt
done