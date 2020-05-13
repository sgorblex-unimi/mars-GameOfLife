## What is the old_code folder?
Some of the source files in the project have a previous version in the "old" folder. Those source files are perfectly functional, although they have been proved to be way less efficient than the present ones. Though they are kept since they somehow better represent the high level language to assembly translation.

In particular, the following modifications have been made:
- the nested loops in the neighbor_counter procedure has been replaced for a multiple cases linear/sequential approach wich saves many instructions per iteration, while making the code more liney
