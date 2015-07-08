
		ASSEMBLY LANGUAGE INSTALLING INSTRUCTIONS

In this file there is a set of installing instructions for each of the
three types of platforms. Choose the set which matches your platform.
The READ_ME files which appear when a zip-file is extracted is a copy
of the part of this file corresponding to the platform.

_______________________________________________________________________________

MS-WINDOWS INSTRUCTIONS FOR INSTALLING THE ASSEMBLER AND TRACER SOFTWARE

To install the software on Windows 2000/XP, follow these steps.

 1. Make a directory, say, tracer, where all the software will go

 2. Place the mswindos.zip file in tracer

 3. Unzip this file by typing: unzip mswindos.zip

In case that you have obtained the self extracting archive "tracer.exe"
these steps 1 through 3 can be replaced by activating this archive file.

 4. Make sure the following files and directories now exist:
	READ_ME       asinstal.bat  examples      release
	bin           exercise      syscalnr.h
	as_src        trce_src

 5. Install the ansi.sys driver as follows. Using the Windows Start button,
    find ansi.sys on the C: drive using
	On Windows 2000:
		Start > Search > For files or folders
	On Windows XP:
		Start > Search > For files or folders > All files and folders

 6. Locate the configuration file. 
	On Windows 2000 usually:
		\WINNT\SYSTEM32\CONFIG.NT
	On Windows XP usually:
		\WINDOWS\SYSTEM32\CONFIG.NT

 7. Add a line at the end of CONFIG.NT telling where ansi.sys is.
    Use notepad or another editor.  Do NOT use Word.  For example:
	device=C:\Windows\system32\ansi.sys

 8. Reboot the system

 9. Start a Command prompt with 
    either: Start > Programs > Accessories > Command prompt
    or:     Start > run    
		enter:    cmd    in the dialogue box
		give: OK

10. Change to the tracer\examples directory with cd

11. Type: 
	t88 HlloWrld
    to run the first example


It should not be necessary to recompile the sources to obtain the
binaries  "s88.exe" and "t88.exe".
copies are available in the "bin", "examples" and "exercise directories.

_______________________________________________________________________________

BIG-ENDIAN INSTRUCTIONS FOR INSTALLING THE ASSEMBLER AND TRACER SOFTWARE

To install the software on Solaris, big endian type UNIX, Apple-Macintosh X and
	Apple-Macintosh Linux machines, follow these steps.

 1. Make a directory, say, tracer, where all the software will go

 2. Place the BigendNx.zip file in tracer

 3. Unzip this file by typing: unzip BigendNx.zip.

 4. Make sure the following files and directories now exist:
	READ_ME       asinstal.sh  examples      Release_Notes
	bin           exercise      syscalnr.h
	as_src        trce_src

 5. For Solaris systems there are binaries available in the bin directory,
        but for the Apple X it is necessary to recompile the sources.
        This can be done by typing: asinstal.sh.  )*

 6. Change to the tracer/examples directory with cd

 7. Type: 
	t88 HlloWrld
    to run the first example

_______________________________________________________________________________

LITTLE-ENDIAN INSTRUCTIONS FOR INSTALLING THE ASSEMBLER AND TRACER SOFTWARE

To install the software on Pentium based Linux, and other little endian
	type UNIX machines, follow these steps.

 1. Make a directory, say, tracer, where all the software will go

 2. Place the LtlendNx.zip file in tracer
	(For Apple Linux use BigendNx.zip in stead of LtlendNx.zip).

 3. Unzip this file by typing: unzip LtlendNx.zip (or BigendNx.zip)

 4. Make sure the following files and directories now exist:
	READ_ME       asinstal.sh  examples      release
	bin           exercise      syscalnr.h
	as_src        trce_src

 5. For Pentium based Linux there are binaries available in the bin directory,
        but for the Apple Linux it is necessary to recompile the sources.
        This can be done by typing: asinstal.sh   )*

 6. Change to the tracer/examples directory with cd

 7. Type: 
	t88 HlloWrld
    to run the first example

___________

)* N.B.
   It is assumed that the current version of the C-compiler is called by the
   command "gcc". If that is not the case, change the lines 
	"CC=gcc" 
   in the files
	"as_src/Makefile"
   and
	"trce_src/Makefile"
   in such a way that the current version of the C-compiler is called instead of gcc.
_______________________________________________________________________________

	THE CONTENTS OF THE SOURCE AND BINARY DIRECTORIES

The precompiled sources can be found in the "bin" directory, but for
convenience there is also a copy of the binaries in the "examples" and
"exercise" directories.

The only important difference between the interpreter "s88" and the
tracer "t88" is that the interpreter does not display the tracer window, and
does not accept tracer commands from standard input, but all other steps
independent of the tracing process are identical.

The source code for the assembler is in the directory "as_src". The source
code for the interpreter "s88" and debugger-tracer "t88" is in the directory
"trce_src". If you want to change any of the tools, you have to recompile
them, in which case you need a working C compiler installed. To compile, type:
	asinstal
which calls the command "make" to recompile the sources and put the binaries
in the directories "bin", "examples" and "exercise".
It is assumed that the current version of the C-compiler is called by the
command "gcc". If that is not the case, change the lines containing "gcc" 
in the files "Makefile" resp. "make.bat" in the directories "as_src" 
and "trce_src" in such a way that the current version of the C-compiler
is called instead of gcc.

Assembler source files have an extension ".s". In order to get a binary
for a source "project.s" the command
	as88 project
should perform the assembly, and generates three files "project.88", which is
the 8088 binary, "project.#" which links the file positions in the source
file to the positions in the binary file, and "project.$", which is just a copy
of the source file which contains also included secondary sources and satisfies
the preferred conventions for the assembly process. The tracer subwindow for
the source file displays the "project.$" version.

Tracing a file is done with the command
	t88 project
which displays the registers, the stack, part of the memory etc. in a set of
windows, such that the execution can be observed. The tracer executes exactly
on assembler command when the return key is hit. Execution stops at command "q"
followed by a return, or when the process itself exits.
Interpretation without tracer window is done with the command 
	s88 project

The entire assembler project uses command line terminal windows. This is
a rather standard procedure for Posix compliant systems, but less usual for
Windows platforms.

Some extra notes on the current implementation, known bugs, and restrictions
can be found in the file "release" in this directory.

The precompiled versions in the file
	BigendNx.zip 	are developed for Solaris UNIX
	LtlendNx.zip 	are developed for Pentium based Linux
	MSWindos.zip	are developed for MS-Windows systems.

Updates to this software and documentation will be placed at
	www.prenhall.com/tanenbaum

Evert Wattel
Vrije Universiteit, Amsterdam
evert@cs.vu.nl (or e.wattel@few.vu.nl)
_______________________________________________________________________________
