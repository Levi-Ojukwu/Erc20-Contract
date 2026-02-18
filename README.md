## Assignment 1

#Question 1
-  Where are your structs, mappings, and arrays stored?

**ANSWER**: Structs, mappings and arrays are state variables, so they are stored in the cotract storage. 


#Question 2
-  How they behave when executed or called?

**ANSWER**: When you call a state variable, the contract reads the value from theblockchian state, modifies them, and write them back to the storage. Note that bothe reading and writing from storage sosts gas.


#Question 3
-  Why don't you need to specify memory or storage with mappings?

**ANSWER**: Mappings are declared at contract level, which makes them state variables. So they are automatically live in storage. Also mapping cannot exist in memory, becasue memory is temporary and linear, but mapping require an unbouded key-based storage.



