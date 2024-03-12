import os
import subprocess

# Define the directory and the program
directory = 'grammars/invalid'
program = './ft_ality'

# Iterate over the files in the directory
for filename in os.listdir(directory):
    # Construct the full path to the file
    file_path = os.path.join(directory, filename)
    
    # Execute the program with the file as an argument
    result = subprocess.run([program, file_path], capture_output=True, text=True)
	
    # Print the output of the program
    print(f'{filename} returns {result.returncode}')
