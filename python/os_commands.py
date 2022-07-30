import os
import subprocess
from sys import stdout

# os module method
os.system("ls -l")

# subprocess method preferred
results = subprocess.run(["ls", "-l"], stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)

print(results.stdout)