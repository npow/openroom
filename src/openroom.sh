#!/bin/bash

# TODO
# - commandline parsing using getopt

cd src && mzscheme -f main.scm -- $@
