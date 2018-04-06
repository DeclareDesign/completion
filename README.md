# Tab completion prototype for DeclareDesign
Prototype for tab completion through handlers.

This provides a custom tab handler for DeclareDesign (see also `?completion` and [jimhester/completeme](https://github.com/jimhester/completeme)).


## Installation

    remotes::install_github("DeclareDesign/completion")

## How it works

Each step declaration function in DeclareDesign has an internal handler function that is partially applied at the time of declaration. 
For those functions, `completion` registers a completion function which can merge in the handler's arguments to the normal completions list.
