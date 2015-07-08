cd trce_src
make
cd ..
cd as_src
make
cd ..
echo "IN ORDER TO MAKE THE WINDOWS\(tm TERMINAL RUN PROPERLY, THE ANSI.SYS COMMANDS"
echo "MUST BE AVAILABLE. Somewhere in the system there is a file "ansi.sys". "
echo "It is found with the find file command in the start menu."
echo "This file should be made available to the system by putting a device indication"
echo "in the system configuration file. On the different WINDOWS system this file"
echo "is either"
echo "		"\WINNT\SYSTEM32\CONFIG.NT""
echo "or"
echo "		"\WINDOWS\SYSTEM32\CONFIG.NT""
echo "or"
echo "		"\WINDOWS\SYSTEM\CONFIG.NT""
echo "or"
echo "		"\CONFIG.SYS""
echo "Somwhere in this file, there has to be a line supplying a device indication:"
echo "resp.			device=%SystemRoot%\system32\ansi.sys"
echo "resp.			device=%SystemRoot%\system32\ansi.sys"
echo "resp.			device=%SystemRoot%\system\ansi.sys"
echo "resp.			device=c:\??????\ansy.sys"
echo "in which the question marks should be filled in such that the appropriate"
echo "path name where the "ansi.sys" file can be found."
echo "If such a line is not in the file, start an editor and add it at the end."
