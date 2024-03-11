# ft_ality

TODO
# wk 1
## Format

## Validation

## Machine building

## Debug mode

# wk 2
## machine execution
- read from stdin
- split all the characters
- call input_machine w/ characters
- recursive loop


input machine
- check if current state is final
- If yes, print final and return
- If no, extract read_char and try to find the read_char in current state
- If not found, print no state found
- If found, amend character list to remove store first character and construct new machine with to_state as new current state 
- recursively call input_machine with amended machine and input