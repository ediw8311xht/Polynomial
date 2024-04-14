#!/bin/bash

####################
( #-START-SUBSHELL-#
####################

main() {
    find tests/ -mindepth 1 -executable -name "*Test*.exs" -exec elixir {} \;
}

main "${@}"

####################
) #---END-SUBSHELL-#
####################
