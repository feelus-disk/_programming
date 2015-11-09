INSTALLING AND GETTING STARTED WITH THE 
8088 ASSEMBLER AND TRACER TOOLKIT (V. 1.0): 
MICROSOFT WINDOWS VERSION

NOTE: If at any point while installing the software supplied on this CD, 
you are presented with an error message that states you do not have the 
correct privileges or permissions to install the software, you will need to 
log off and then log on as the Administrator (or as another user with 
administrative permissions). If you are installing this software at a company, 
educational institution, or other organizational site, you may need to ask your 
system administrator for assistance or for an appropriate password.

I. COPYING THE 8088 ASSEMBLER AND TRACER TOOLKIT 
SOFTWARE TO YOUR HARD DISK

1. If you have not done so already, create a directory named tracer on your hard 
disk. This is where you will place all the software in the 8088 Assembler and 
Tracer Toolkit. 

2. If you have not done so already, browse the CD-ROM to the 
8088_tracer\windows directory, and copy all of its contents to the new tracer 
directory you just created on your hard disk. 
   
3. Make sure the following directories and files now exist within your new tracer 
directory:

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

II. CONFIGURING YOUR SYSTEM

In this part of the installation process, you make sure Windows' ansi.sys driver is 
available to the 8088 Assembler and Tracer Toolkit. To do so, you must first
locate ansi.sys, and then locate and (possibly) edit another file named config.nt. 
Follow these steps:

1. Locate ansi.sys using Windows' file search feature. For example, in Windows XP,
click Start > Search > For Files and directories. Make a note of where you found ansi.sys. 

2. Locate config.nt, and open it with a text editor such as Notepad. (Do NOT use 
a word processor such as Word, which would add formatting that would prevent 
the file from being read properly.).

On many systems, config.nt will be in the same directory as ansi.sys. If not, you can 

find it with Windows' file search feature. 


3. In config.nt, look for a line containing a device indication command that directs
Windows to look for the ansi.sys file in the location you found it. Depending on 
your system, the line may resemble one of these examples:

       device=%SystemRoot%\system32\ansi.sys
or 
       device=%SystemRoot%\system32\ansi.sys
or
       device=%SystemRoot%\system\ansi.sys

4. If no such line appears, add one, in the following format:

       device=c:\??????\ansi.sys

(where ?????? is replaced by the path name where ansi.sys appears on your system)

5. Save the config.nt file.

III. TESTING YOUR CONFIGURATION

1. Reboot your computer.

2. Display a command prompt (Start > Programs > Accessories > Command Prompt),
and change to the tracer directory, using the following command: 


	cd tracer

3. Run the first example program. Type: 

	t88 HlloWrld

IV. GETTING STARTED WITH THE ASSEMBLER AND TRACER SOFTWARE

Within the tracer directory, you can find precompiled sources in the bin directory. For your
convenience, there are also copies of the binaries in the examples and exercise directories.

Source code for the assembler is in the directory as_src. Source code
for the interpreter "s88" and debugger-tracer "t88" is in the
directory "trce_src".

The only important difference between the interpreter "s88" and the
tracer "t88" is that the interpreter does not display the tracer window,
and does not accept tracer commands from standard input. All other
steps independent of the tracing process are identical.

Source code files are in the language C, and in each directory, the
command "make" should recompile the sources and place the binaries
in the directories "bin", "examples", and "exercise".

A. CREATING BINARIES

Assembler source files have an extension ".s". To create a binary
for a source named "project.s", enter the command:

	as88 project

This performs the assembly, and generates three files:

	project.88	The 8088 binary

	project.#	A file which links the file positions in the source
   		file to the positions in the binary file)

	project.$	A copy of the source file which contains included
   		secondary sources and satisfies preferred conventions
   		for the assembly process

The tracer subwindow for the source file displays the "project.$" version.

B. TRACING

To trace a file, use the command "t88". For example, to trace a file
named "project," enter the command:

	t88 project

This displays the registers, stack, portions of memory, and other
information in a set of windows, enabling you to observe execution.

The tracer executes exactly on assembler command when the return key is
hit. To stop execution, type the command "q", followed by a return.
Execution stops on its own when the process itself exits.

To interpret a file without displaying the tracer window, use the s88
Command. For example, to interpret a file named "project," enter the command:

	s88 project

The entire assembler project uses command line terminal windows. This is
commonplace on Posix compliant systems, but less typical for Windows
platforms.

Some extra notes on the current implementation, known bugs, and restrictions
can be found in the file "release" in this directory.

Good Luck,
Evert Wattel
Vrije Universiteit, Amsterdam
evert@cs.vu.nl (or e.wattel@few.vu.nl)
