import random

lower_case = "abcdefghijklmnopqrstuvwxyz"
upper_case = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
number = "0123456789"
symbols = "@#$%&*/\?"

pass_chars = lower_case + upper_case + number + symbols
length_for_pass = 10

password = "".join(random.sample(pass_chars, length_for_pass))

print(f"Your generated password is: {password}")