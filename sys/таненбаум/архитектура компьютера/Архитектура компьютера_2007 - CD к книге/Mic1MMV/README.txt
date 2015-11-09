INSTALLING AND GETTING STARTED WITH THE 
Mic-1 MMV SIMULATOR (V. 2.0)
(ALL SUPPORTED PLATFORMS)

This README file will help you get acquainted with the Mic-1 MMV
simulator. It contains the following sections:

   I.   Copying the Mic-1 MMV Simulator Software to Your Hard Disk
   II.  Installation
   III. Examples
   IV.  Using the Help System

The Mic-1 MMV Simulator includes a complete Help system 
containing detailed information on using it, as well as detailed references
to the two assembly languages it supports. For more information on
the Help system, see Section IV. 

I. COPYING THE Mic-1 MMV SIMULATOR SOFTWARE 
TO YOUR HARD DISK

1. If you have not done so already, copy the entire Mic1MMV directory 
from the CD-ROM to your hard disk. 


2. Locate the Mic1MMV directory on your hard disk, and make
sure it contains the following subdirectories and files: 

bin subdirectory, containing the following files: 

   Mic1MMV_hr.jar (executable Java jar file containing high-resolution 
	version of the simulator program)
   Mic1MMV_lr.jar (executable Java jar file containing low-resolution
	version of the simulator program)
   runMic1.bat (batch file for launching the simulator)

lib subdirectory, containing the following files: 
   ijvm.conf (configuration file for the ijvmasm assembler; also contains 
	a description of the assembly language, including opcode, 
	mnemonic, and operand types for each instruction)
   mic1.properties (sample properties file)
   GNU.TXT (copy of the GNU General Public License applying to this
	software)

examples subdirectory, containing the following subdirectories: 
   MAL (subdirectory containing mic1ijvm.mal, the source micro
	assembly language file (MAL file) for the standard IJVM
	interpreter.
   JAS-IJVM (subdirectory containing several sample Integer Java Virtual
	Machine [IJVM] programs, in source code form [JAS files]
	and object code form [IJVM files]).

doc subdirectory, containing the following files: 
   UserGuide.jar (standalone version of the user guide; to run, either 
	double-click, or launch from the command line with the
	following command: java -jar UserGuide.jar)

   UserGuide_hs.jar (JavaHelp helpset for this user guide; must remain in
	the same directory as UserGuide.jar) 

src subdirectory, containing the following file: 
	mic1mmv.zip (Zip file containing source code for Mic-1 MMV)

	    Note: The Mic-1 MMV jar files in this release bundle the
	    Javahelp classes contained in the archive jh.jar,
	    distributed by Sun Microsystems and licensed as part of
	    the Java 2 Standard Edition. See
	    http://java.sun.com/products/javahelp/.  This source zip
	    only contains files for which the copyright is owned by
	    Prentice Hall. Recompilation will require reference to the
	    files of jh.jar in the classpath.

II. INSTALLATION

The Mic-1 MMV software requires the Java Runtime Environment 
(JRE) 1.4 or later. Before proceeding, make sure it is installed properly. 

If you have not installed JRE 1.4 or later, visit 
http://java.sun.com/j2se/ to download a JDK or JRE for your platform. 
Follow Sun's instructions to install JRE 1.4 or later before you install 
Mic-1 MMV. 

Windows users: When you install Java, the Java installer should make sure
your PATH variable points to the Java bin directory. If it does not, edit
your PATH variable manually to do so. 

Unix/Linux users: Your Java PATH environment variables must contain the
path of the JDK executables. To make sure your Java PATH environment 
variables are set properly, type the following command: which java

If a directory path is returned, the PATH is properly set. If nothing is 
returned, you must find the jdk and set the PATH manually. 

Macintosh users: At the end of the installation process, check that the Java
JRE is properly installed by attempting to launch the Mic-1 MMV jar file, 
as shown below.  

The following instructions assume you have already copied the Mic1MMV 
directory from the CD-ROM to your hard disk, and checked its contents, 
as discussed in Section I. 


1. Locate the bin subdirectory within the Mic1MMV directory on your hard 
disk, and select the appropriate jar file for your system: 

   Mic1MMV_hr.jar (for high-resolution screens running at 1280x960 or higher)
   Mic1MMV_lr.jar (for lower-resolution screens running at resolutions lower 
	than 1280x960)

2. Rename the appropriate file as Mic1MMV.jar.

3. Double-click on the jar file you selected, or launch from the command line 
with the following command: 

      java -jar Mic1MMV.jar

   Alternatively, edit the batch file runMic1.bat and use it to launch the 
   simulator. Instructions for editing runMic1.bat are contained
   in that file.

III. EXAMPLES

This section presents basic examples to help you get started quickly with 
the Mic-1 MMV simulator. 

Example 1: Loading and Running an IJVM Program

This example shows you how to load an IJVM program and run it without
interruption. 

1. Launch the simulator, as described in Installation Step 3. 

2. Choose File > Load IJVM program from the Mic-1 MMV menu bar. 


3. In the File chooser, navigate to the examples/JAS-IJVM Examples 
   subdirectory. If you have launched from the bin directory, this 

   directory is found by moving up one level, then down through 
   the "examples" directory.

4. Select ijvmtest.ijvm. The IJVM program should appear in the Method Area.

5. Select Prog Speed on the Command Console (i.e. the radio button
   labeled "Prog").


6. Click the Run button (the one with the blue right arrow) on the
   Command Console to begin interpretation of the IJVM program by the
   default microprogram. After a brief period, while the simulator is
   running, you should see the following in the "Output Console" text
   area:

       OK

Example 2: Assembling a JAS Program

This example shows you how to edit, and assemble a JAS source program,
and load the resulting IJVM object program.

1. Find the following file: examples/JAS-IJVM Examples/ijvmtest.jas 

2. Open this file in your favorite text editor (emacs, Notepad, etc.)

3. Go to line 451.

4. Replace the lines:

      OK:	BIPUSH 79
		OUT
		BIPUSH 75
		OUT
		HALT
   with

      OK:	BIPUSH 65
		OUT
		BIPUSH 79
		OUT
		BIPUSH 75
		OUT
		HALT

5. Save the changes.


6. Choose File > Assemble/Load IJVM program from the 
   Mic-1 MMV menu bar. 

7. Navigate to examples/JAS-IJVM, and select the following file:

   ijvmtest.jas

8. The "Assembling ijvmtest.jas ..." window should appear, with
   "assembly complete" appearing soon in the text area. Click the Load
   button.

9. Select Prog Speed and click Run. The Output Console should 
   now display: 

      AOK

Example 3: Re-Assembling a JAS Program

Once a JAS file has been assembled and loaded, it can be re-assembled
and loaded using the Mic-1 Menu bar command 
Assemble/Load > Current JAS Assemble/Load. No further file selection
is required. 

This example also shows what happens when there is an error in a 
JAS program.

1. After completing Example 1, re-edit ijvmtest.jas, remove the colon
   after OK, and save the changes:

      OK	BIPUSH 65
		OUT
		BIPUSH 79
		OUT
		BIPUSH 75
		OUT
		HALT

2. Choose Assemble/Load > Current JAS Assemble/Load from the 
   Mic-1 MMV menu bar. 

   The "Assembling ijvmtest.jas" window should appear with the
   following error message:

	 IJVM Assembler...
	 1433: Invalid instruction: ok
	 1424: Invalid goto label: ok

3. Close the window and re-edit the file. Restore the colon, and
   remove the lines

	 BIPUSH 65
	 OUT
	 
   so the program looks like it did originally. 

4. Try Step 2 again. This time, no error message will be displayed. 
   Load the program, click the Reset button, and run it again.  
   The result in the Output Console should be "OK", just like the 
   first time.

Example 4: Trying different speeds.

This example shows how the simulator operates at different
"speeds". Here, "speed" means the amount of computation that takes
place when the Run button is clicked once. You will also see how to
use the Delay Mode to demonstrate the simulator's action. 

1. Launch the simulator, and choose File > Assemble/Load IJVM 
   program from the menu bar. 

2. Select the file: examples/JAS-IJVM/add.jas. 

3. Load the program when it finishes assembling. 

4  Try the program first at Prog Speed. This program adds 2 
   hexadecimal numbers. Run it, and type the following into the 
   Input Console:

	1234   	
	5678

   Note the echoing in the Output Console. When you are done, the
   Output Console should contain

	  1234
       	+5678
          ========
           000068AC

   You can enter another pair of numbers to sum in the Input
   Console. (Be sure to use capitals A ... F for the high-end hex
   digits.) Click "Stop" (the stop sign) when you are done.

5. Now, click Reset, and change the speed to IJVM Speed.

6. Click the Run button several times, and note the highlighting of
   IJVM instructions in the Method Area. Each click executes a single
   IJVM instruction. You can also click the Reverse button (the
   left-pointing red arrow) to back up a step.

7. Now, click the Delay On button, and click Reset and the
   Run button as in the previous step. Note that the sequence of
   microcode instructions used to interpret the current IJVM
   instruction is shown, and the data path is illustrated in the
   Architecture View. (The leftmost window shows registers 
   and busses).

8. Select Delay Off and Clock Speed. Then, Reset and Run 
   several steps. Each step shows the execution of one 
   microinstruction. The Reverse button backs up one 
   microinstruction. 

9. On the Menu Bar, choose Microstore >View Microstore. 
   The Microstore Window will appear, and you can follow the 
   execution of the microprogram while clicking Run. Try it with 
   Delay on to see the subcycles illustrated as before. 
   
10. Finally, select Delay Off and SubClock Speed, then 
   Reset and Run several steps. Each step is now a quarter cycle. 
   Reverse works as you'd expect, but Delay On has no effect 
   at this speed.

IV. USING THE HELP SYSTEM

User Guide
     The complete documentation for the Mic-1 MMV microarchitecture
     simulator and related software can be launched by selecting Help
     > Mic1MMV Help from the Menu Bar. You can also run it 
     apart from the simulator, by running docs/UserGuide.jar. Either 
     double-click on the UserGuide.jar icon, or enter the following
     command:

	   java -jar UserGuide.jar

Context-sensitive Help
     The Menu entry Help > Mic-1 MMV Help On launches
     context-sensitive help. You can use this to get help about any 
     GUI object. When selected, the cursor changes to the
     help cursor. When the user next clicks on a GUI object, help
     information for that object is displayed.

To browse Help, launch the Help browser, and make a selection 
from the Table of Contents pane on the left. Among the sections 
you can visit are:

Getting Started
	Similar material to this README.

Program Operation
	The Overview has a Visual Quick Tour. The diagrams in this
	section are "hot": you can click on a feature and jump to a
	description of that feature.

	Running the Simulator describes running at different speeds
	and contains an example that demonstrates setting breakpoints.

	Setting Preferences describes the Preference panel, and the
	user options you can set.

	Controls and Viewers are detailed descriptions of each 
	Mic-1 MMV feature.

	Using Mic-1 MMV describes how you can develop 
	microcode programs using the simulator, analogous to the 

	JAS > IJVM examples presented in Section III. This
	section also discusses modifying the JAS assembler.

Programming Manuals
	Specifications of the MAL and JAS languages.

