INSTALLING AND GETTING STARTED WITH THE 8088 
ASSEMBLER AND TRACER TOOLKIT (V. 1.0)

I. INTRODUCTION

This file contains 8088 Assembler and Tracer Toolkit installation 
instructions for each of three platforms: 

* Microsoft Windows
* Intel/Linux (e.g., little endian) platforms
* SPARC/Solaris (e.g., big endian) platforms

A copy of the individual installation instructions for each platform is also 
provided in the README.txt subdirectory containing the correct software 
files for that platform. 

This README.txt (and the individual README.txt files within each 
subdirectory) also contain brief information to help you get started working 
with 8088 Assembler and Tracer Toolkit. For more detailed information, 
see Appendix C of the book. 

______________________________________________________________

II. INSTALLATION INSTRUCTIONS FOR MICROSOFT WINDOWS

NOTE: If at any point while installing the software supplied on this CD, 
you are presented with an error message that states you do not have the 
correct privileges or permissions to install the software, you will need to 
log off and then log on as the Administrator (or as another user with 
administrative permissions). If you are installing this software at a company, 
educational institution, or other organizational site, you may need to ask your 
system administrator for assistance or for an appropriate password.

To install this software on Microsoft Windows, follow these steps:

A. COPYING THE 8088 ASSEMBLER AND TRACER 
TOOLKIT SOFTWARE TO YOUR HARD DISK

1. If you have not done so already, create a directory named 
tracer on your hard disk. This is where you will place all the 
software in the 8088 Assembler and Tracer Toolkit. 

2. If you have not done so already, browse the CD-ROM to the 
8088_tracer\windows directory, and copy all of its contents to 
the new tracer directory you just created on your hard disk. 

3. Make sure the following directories and files now exist 
within your new tracer directory:

Directories: 

as_src
bin
examples
exercises
trce_src

Additional files in the main tracer directory: 

asinstal.bat
README.txt
release.txt
syscalnr.h

B. CONFIGURING YOUR SYSTEM

In this part of the installation process, you make sure Windows' 
ansi.sys driver is available to the 8088 Assembler and Tracer 
Toolkit. To do so, you must first locate ansi.sys, and then 
locate and (possibly) edit another file named config.nt. Follow 
these steps:

1. Locate ansi.sys using Windows' file search feature. For 
example, in Windows XP, click Start > Search > For Files and 
directories. Make a note of where you found ansi.sys. 

2. Locate config.nt, and open it with a text editor such as 
Notepad. (Do NOT use a word processor such as Word, which 
would add formatting that would prevent the file from being 
read properly.).

On many systems, config.nt will be in the same directory as 
ansi.sys. If not, you can find it with Windows' file search 
feature. 

3. In config.nt, look for a line containing a device indication 
command that directsWindows to look for the ansi.sys file in 
the location you found it. Depending on your system, the line 
may resemble one of these examples:

       device=%SystemRoot%\system32\ansi.sys
or 
       device=%SystemRoot%\system32\ansi.sys
or
       device=%SystemRoot%\system\ansi.sys

4. If no such line appears, add one, in the following format:

       device=c:\??????\ansi.sys

where ?????? is replaced by the path name where ansi.sys 
appears on your system.

5. Save the config.nt file.

C. TESTING YOUR CONFIGURATION

1. Reboot your computer.

2. Display a command prompt (Start > Programs > Accessories 
> Command Prompt). 

3. Change to the tracer directory, using the following command: 

cd tracer

4. Run the first example program. Type: 

   t88 HlloWrld
______________________________________________________________

III. INSTALLATION INSTRUCTIONS FOR SOLARIS

To install this software on Solaris systems, follow these steps:

A. COPYING THE 8088 ASSEMBLER AND TRACER 
TOOLKIT SOFTWARE TO YOUR HARD DISK

1. If you have not done so already, create a directory named 
tracer on your hard disk. This is where you will place all the 
software in the 8088 Assembler and Tracer Toolkit. 

2. If you have not done so already, browse the CD-ROM to the 
/8088_tracer/solaris directory, and copy all of its contents to 
the new tracer directory you just created on your hard disk. 

3. Make sure the following directories and files now exist 
within your new tracer directory:

Directories: 

as_src
bin
examples
exercises
trce_src

Additional files in the main tracer directory: 

asinstal.bat
README.txt
release.txt
syscalnr.h

B. TESTING 8088 ASSEMBLER AND TRACER TOOLKIT 

1. Change to the /tracer/examples directory. 

2. Run the first example program. Type: 

   ./t88 HlloWrld
______________________________________________________________

IV. INSTALLATION INSTRUCTIONS FOR INTEL-BASED 
LINUX SYSTEMS

A. COPYING THE 8088 ASSEMBLER AND TRACER 
TOOLKIT SOFTWARE TO YOUR HARD DISK

1. If you have not done so already, create a directory named 
tracer on your hard disk. This is where you will place all the 
software in the 8088 Assembler and Tracer Toolkit. 

2. If you have not done so already, browse the CD-ROM to the 
/8088_tracer/linux directory, and copy all of its contents to 
the new tracer directory you just created on your hard disk. 

3. Make sure the following directories and files now exist 
within your new tracer directory:

Directories: 

as_src
bin
examples
exercises
trce_src

Additional files in the main tracer directory: 

asinstal.bat
README.txt
release.txt
syscalnr.h

B. TESTING 8088 ASSEMBLER AND TRACER TOOLKIT 

1. Change to the /tracer/examples directory. 

2. Run the first example program. Type: 

   ./t88 HlloWrld

______________________________________________________________

V. NOTES ON INSTALLING THIS SOFTWARE ON OTHER 
UNIX SYSTEMS

As noted, the Linux binaries should work on diverse Pentium/x86 
Linux systems, and the Solaris binaries should work on Solaris systems. 
If you wish, you may follow these steps to recompile the 8088 Assember and 
Tracer Toolkit sources for other UNIX platforms. Note that Prentice Hall only 
supports this software running on Microsoft Windows, Red Hat Linux 9, and 
Solaris 10.

1. Choose the directory that contains the sources you need. For little-endian 
machines, use the linux directory; for big-endian machines, use the solaris 
directory. 

2. Check to make sure your system will call the correct C compiler. By default, 
it is assumed that the current version of the C compiler is called by the
command "gcc". If that is not the case, change the lines 

	"CC=gcc" 

in the files
	"as_src/Makefile"

and
	"trce_src/Makefile"

in such a way that the current version of the C-compiler is called instead 
of gcc.

______________________________________________________________

VI. GETTING STARTED WITH THE 8088 ASSEMBLER 
AND TRACER TOOLKIT

A. INTRODUCTION

This section contains notes intended to help you quickly begin 
working with the 8088 Assembler and Tracer Toolkit. For 
more detailed instructions, please see Appendix C of the book. 

Within the tracer directory, you can find precompiled sources 
in the bin subdirectory. For your convenience, copies of the 
binaries also appear in the examples and exercise 
subdirectories.

Source code for the assembler is in the subdirectory as_src. 
Source code for the interpreter "s88" and debugger-tracer "t88" 
is in the subdirectory trce_src.

The only important difference between the interpreter "s88" 
and the tracer "t88" is that the interpreter does not display the 
tracer window, and does not accept tracer commands from 
standard input. All other steps independent of the tracing 
process are identical.

B. COMPILATION

C-based source files are provided in the event you ever need
to recompile this software. On Unix and Linux platforms, 
the command "make" should recompile the sources and place 
the binaries in the directories "bin", "examples", and 
"exercise."

To recompile, you need a working C compiler installed. If you 
have one, you can compile by typing:

   asinstal

After you compile, either move your executable files to a 
program directory, or change the PATH variable to make the 
assembler "as88" and the tracer "t88" visible from the 
directories containing the assembly source codes.

C. CREATING BINARIES

Assembler source files have an extension ".s". To create a 
binary for a source named "project.s", enter the command:

   as88 project

This performs the assembly, and generates three files:

project.88	The 8088 binary
project.#	A file which links the file positions in the source
   	file to the positions in the binary file)
project.$	A copy of the source file which contains included
   	secondary sources and satisfies preferred conventions
   	for the assembly process

The tracer subwindow for the source file displays the 
"project.$" version.

D. TRACING

To trace a file, use the command "t88". For example, to trace a 
file named "project," enter the command:

   t88 project

This displays the registers, stack, portions of memory, and 
other information in a set of windows, enabling you to observe 
execution.

The tracer executes exactly on assembler command when the 
return key is hit. To stop execution, type the command "q", 
followed by a return. Execution stops on its own when the 
process itself exits.

To interpret a file without displaying the tracer window, use 
the s88 Command. For example, to interpret a file named 
"project," enter the command:

   s88 project

The entire assembler project uses command line terminal 
windows. This is commonplace on Posix compliant systems, 
but less typical for Windows platforms.

Additional notes on the current implementation, known bugs, 
and restrictions can be found in the file release.txt in this 
directory.

Good Luck,
Evert Wattel
Vrije Universiteit, Amsterdam
evert@cs.vu.nl (or e.wattel@few.vu.nl)
