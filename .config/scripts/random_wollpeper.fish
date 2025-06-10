#!/usr/bin/fish

# Generate a random number between 0 and 32767
set -l random_num $RANDOM

# Calculate a random number between 1 and 5 (inclusive)
# $RANDOM % 5 will give a number from 0 to 4
# Add 1 to shift the range to 1 to 5
set -l result (math 1 + ($random_num % 5))

# Output the result

