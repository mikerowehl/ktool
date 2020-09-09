# ktool

A Docker containerized cross-compile toolchain for building bootable images
and operating system services. This uses the method described on the OSDev wiki
[make an i686-elf cross compiler](https://wiki.osdev.org/GCC_Cross-Compiler).
Then I also borrowed some ideas from the
[dockcross](https://github.com/dockcross/dockcross) tools to make it a bit
easier to run the tools from the container using a wrapper script.

## Usage

Assuming you have Docker installed and setup already you should be able to use
the toolchain by just installing the ktool wrapper script from this repo. I do
most of my work on OS X and some on Linux, so I've somewhat tested out those
two. I can't really help with running on Windows. But it appears the dockcross
tools do work under Windows, so if you need to make this work on Windows maybe
check to see what
[dockcross](https://github.com/dockcross/dockcross) does.
I'll give some examples for OS X, but they should be pretty close for Ubuntu
as well.

I have a 
[public image up on Docker Hub](https://hub.docker.com/repository/docker/mikerowehl/ktool)
so all you should have to do is grab the ktool script from this repo, make it
executable, and put it somewhere in your PATH. The first time you try to run
the script it will pull down the Docker image with the toolchain. Try running
a version check on the gcc compiler in the container for example:

```
ktool i686-elf-gcc --version
```

You should get back something like this:

```
i686-elf-gcc (GCC) 10.2.0
Copyright (C) 2020 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
```

I use the tools in the container to experiment with some of the examples from 
the OSDev wiki. You should be able to compile anything from the
[Bare Bones](https://wiki.osdev.org/Bare_Bones) examples if you need a place
to start. 
Assuming you have boot.s, kernel.c and linker.ld in your current directory
you should be able to:

```
ktool i686-elf-as boot.s -o boot.o
ktool i686-elf-gcc -c kernel.c -o kernel.o -std=gnu99 -ffreestanding -O2 -Wall -Wextra
i686-elf-gcc -T linker.ld -o myos.bin -ffreestanding -O2 -nostdlib boot.o kernel.o -lgcc
```

The ktool script mounts the current working directory inside the container by
default, so you don't have to worry about copying files into or back out of 
the container. You should have a myos.bin file in the current directory after
you run those three commands. And you should be able to run it on your host
system to make sure everything worked correctly:

```
qemu-system-i386 -kernel myos.bin
```
