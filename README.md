# /dev/log for ft_ality
This project is about creating a **finite state automata** that recognizes regular languages under the scope if a user defined grammar.

In this context, we will create a program that reads from a file to read the keymaps and the states and transitions our finite state automata will adopt to;

We will then parse the information to a machine-like structure and simulate the execution on that structure by running a shell where the user inputs the input string to the finite state machine structure.

# Week 1
## Grammar format
The grammar will be defined like so 
```
<keystroke (single and unique alphabet)>:<symbol (nospace and unique)>:<name (unique)>
.
.
---
<movename (unique)>:<symbol (need to exist)>:<symbol (need to exist)>(symbol combinations need to be unique).....
.
.
```
The grammar file will be seperated into two parts by a seperator `---`; The top part will store the keymaps (what key does what action) and the bottom part will store the movemaps (what actions combined into what move)

They have their own validation constraint to prevent collisions and misconfiguration. A correct grammar file looks like this : 

```
a:[SP]:Special attack
b:[BL]:Block
c:[L]:Left
d:[R]:Right
---
Hadouken:[SP]:[SP]:[BL]
Charge:[BL]:[L]
Smash:[L]:[R]:[SP]
```

Each keymap is seperated into 3 items by the seperator `:`. The first item will be the actual keystroke the user will make. The second item will be the symbol to represent that action. The program and the movemap will match the actions using this field. The third item is a name for this action; this is purely for aestetic and readability purposes.

Each movemap is seperated into 2 or more items using the seperator `:`. THe first item represents the name of the move, which will be the move that is dislayed when the actions are valid. The following items are actions needed to be made to execute said move. Those actions should reflect the action symbols defined in the keymap section.

## Machine building
Once we have parsed the grammar, we can use it to build the finite state machine. A formal definition if a finite state machine is as follows

![image](https://hackmd.io/_uploads/SkxacCAa6.png)

In our case, the input alphabet would be a list of keystrokes from the keymap.

The states would be a global initial state, certain permitations of the symbols to the moves (discussed later)

The transition map will be generated in a way such that if the correct sequence of keys is read, it should lead to the final state, which is the accepting state where a move can be recognized.

With that said, there are a couple of challenges when generating the transitions and states; the 2 major ones are common branches and homonymous states

Say we have 2 moves like so: 
```
Hadouken:[SP]:[L]:[BL]
Charge:[SP]:[L]
Smash:[SP]
```
we should be able to execute all states without collision or mistakes. The way we can build our FSM is 

![image](https://hackmd.io/_uploads/H17Xw7yRT.png)

However, a flaw for this nethod is we are unable to identify repeating characters such as `[SP]:[SP]:[SP]:[BL]`, the states will overlap and some states would be skipped; one other alternative approach is to split the branches by creating identifiers for the repeating states like so.

![image](https://hackmd.io/_uploads/S1JROmJCa.png)

This way, we get a more explicit representation of our branches and we can avoid collisions since no 2 states share the same name. This same apprach can be used on  homonymous states like these

```
Frontflip:[A]:[A]
Backflip:[A]:[A]
Sideflip:[A]:[A]
4DFlip:[B]:[A]:[A]
```

![image](https://hackmd.io/_uploads/rkSr5Qy0T.png)


# Week 2
## Machine execution
Machine execution is quite trivial, we just follow the following steps
1. Read from stdin
2. Check if current state is final
3. If yes, print final and return
4. If no, extract first character and try to find all the possible moves based on the read char and the current state
5. If not found, just return
6. Iterate through all the moves and recurse to step 2 with modified input without the first character and amended current state
