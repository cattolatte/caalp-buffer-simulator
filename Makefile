CC = gcc
CFLAGS = -fno-stack-protector -D_FORTIFY_SOURCE=0 -O0

build:
	$(CC) $(CFLAGS) src/vulnerable.c -o simulator

clean:
	rm -f simulator