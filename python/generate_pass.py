import random

lower_case = "abcdefghijklmnopqrstuvwxyz"
upper_case = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
number = "0123456789"
symbols = "@#$%&*/\?"

use_for = lower_case + upper_case + number + symbols
length_for_pass = 10

password = "".join(random.sample(use_for, length_for_pass))

print(f"Your generated password is: {password}")