import subprocess

prism = "C:\Program Files\prism-4.5\bin\prism"
subprocess.call([prism, "fly.pm", "-simpath", "10", "path.txt"], shell=True)
