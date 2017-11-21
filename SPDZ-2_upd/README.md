How to use the SPDZ-2 pkg:
==========================
1) Write a new program titled "example.mpc" and place it in the Programs/Source folder.

2) Compile it as ../SPDZ-2-master/compile.py example. (Note that you must run from one level above the root folder.

3) Edit both the shell scripts for run-online.sh and setup-online.sh as below:
SPDZROOT=/home/akannan/spdz2/SPDZ-2-master/Scripts/.. (CHANGE TO YOUR RESPECTIVE ROOT PATH)

4) If this isn't done, the shell scripts should also be run from one level above the root as ../SPDZ-2-master/Scripts/run-online.sh

5) If step 3 is done, run the setup script for the offline phase as Scripts/setup-online.sh.
(This sets up parameters for the online phase for 2 parties with a default value of 128-bit finite field and 40-bit binary field, 
and creates offline data (multiplication triples etc.) for these parameters.)

6) Then run the online stage as Scripts/run-online.sh example
(This runs the online stage for 2 players, by default, on the same machine).

To increase the modulus size being used:
========================================
Max mod size = (len(p) / 64 (for 64 bits)) + 1
1) Set the MAX_MOD_SZ flag to 20 in CONFIG and make clean and make again. (Max supported mod size is 512 as per Setup.cpp)

2) Change both setup-online.sh and run-online.sh to generate 512 bit field length.

Other updates:
==============
1) mult.mpc has been added to multiply 20000 numbers. If this number is changed the script should be    	recompiled as in Step 2 above.
2) run-online.sh has been changed to allow running any script 'NTrials' number of times. 
   To run the script, change NTrials to the required number of iterations and execute as in Step 6 above.
3) The average time for stated number of iterations will be displayed.

(C) 2017 University of Bristol. See License.txt

Software for the SPDZ and MASCOT secure multi-party computation protocols.
See `Programs/Source/` for some example MPC programs, and `tutorial.md` for
a basic tutorial.

See also https://www.cs.bris.ac.uk/Research/CryptographySecurity/SPDZ

#### Requirements:
 - GCC
 - MPIR library, compiled with C++ support (use flag --enable-cxx when running configure)
 - libsodium library, tested against 1.0.11
 - CPU supporting AES-NI and PCLMUL
 - Python 2.x, ideally with `gmpy` package (for testing)

#### OS X:
 - `g++` might actually refer to clang, in which case you need to change `CONFIG` to use GCC instead.
 - It has been reported that MPIR has to be compiled with GCC for the linking to work:
   ```./configure CC=<path to GCC gcc> CXX=<path to GCC g++> --enable-cxx```

#### To compile SPDZ:

1) Optionally, edit CONFIG and CONFIG.mine so that the following variables point to the right locations:
 - PREP_DIR: this should be a local, unversioned directory to store preprocessing data (defaults to Player-Data in the working directory)

2) Run make (use the flag -j for faster compilation with multiple threads)


#### To setup for the online phase

Run:

`Scripts/setup-online.sh`

This sets up parameters for the online phase for 2 parties with a 128-bit prime field and 40-bit binary field, and creates fake offline data (multiplication triples etc.) for these parameters.

Parameters can be customised by running

`Scripts/setup-online.sh <nparties> <nbitsp> <nbits2>`


#### To compile a program

To compile the program in `./Programs/Source/tutorial.mpc`, run:

`./compile.py tutorial`

This creates the bytecode and schedule files in Programs/Bytecode/ and Programs/Schedules/

#### To run a program

To run the above program (on one machine), first run:

`./Server.x 2 5000 &`

(or replace `5000` with your desired port number)

Then run both parties' online phase:

`./Player-Online.x -pn 5000 0 tutorial`

`./Player-Online.x -pn 5000 1 tutorial` (in a separate terminal)

Or, you can use a script to do the above automatically:

`Scripts/run-online.sh tutorial`

To run a program on two different machines, firstly the preprocessing data must be
copied across to the second machine (or shared using sshfs), and secondly, Player-Online.x
needs to be passed the machine where Server.x is running.
e.g. if this machine is name `diffie` on the local network:

`./Player-Online.x -pn 5000 -h diffie 0 tutorial`

`./Player-Online.x -pn 5000 -h diffie 1 tutorial`

#### Compiling and running programs from external directories

Programs can also be edited, compiled and run from any directory with the above basic structure. So for a source file in `./Programs/Source/`, all SPDZ scripts must be run from `./`. The `setup-online.sh` script must also be run from `./` to create the relevant data. For example:

```
spdz$ cd ../
$ mkdir myprogs
$ cd myprogs
$ mkdir -p Programs/Source
$ vi Programs/Source/test.mpc
$ ../spdz/compile.py test.mpc
$ ls Programs/
Bytecode  Public-Input  Schedules  Source
$ ../spdz/Scripts/setup-online.sh
$ ls
Player-Data Programs
$ ../spdz/Scripts/run-online.sh test
```

#### Offline phase (MASCOT)

In order to compile the MASCOT code, the following must be set in CONFIG or CONFIG.mine:

`USE_GF2N_LONG = 1`

It also requires SimpleOT:
```
git submodule update --init SimpleOT
cd SimpleOT
make
```

If SPDZ has been built before, any compiled code needs to be removed:

`make clean`

HOSTS must contain the hostnames or IPs of the players, see HOSTS.example for an example.

Then, MASCOT can be run as follows:

`host1:$ ./ot-offline.x -p 0 -c`

`host2:$ ./ot-offline.x -p 1 -c`
