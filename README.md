# ExtundeleteX

## Disclaimer - Still broken
Currently ExtundeleteX is still broken and will segfault when you attempt to use it.

Once it is fixed this disclaimer will be removed.

## Requirements
To compile and install this program, you should first install the binary and development packages for e2fsprogs and e2fslibs.  You must also have a C++ compiler and a make utility to compile extundelete.

## Installation
### Acquiring sources
To compile the program from source, either download the [latest release](https://github.com/AbysmalBiscuit/ExtundeleteX/releases) or clone the repository to build the latest version:
```bash
git clone https://github.com/AbysmalBiscuit/ExtundeleteX.git
```

### Building Using make
#### Configuring and building
Run the following commands from the `extundeletex-x.y.z` or `ExtundeleteX` directory:
```bash
./configure
make
```
#### Installing
The extundelete program may be run as-is from the build
directory, or you may wish to install it to a directory
that is shared with other executable programs, which you
may do by running the following command:
```bash
make install
```
#### Example full installation compilation instructions for extundelete:
```bash
git clone https://github.com/AbysmalBiscuit/ExtundeleteX.git
cd ExtundeleteX
./configure
make
src/extundelete --help
```

### Building Using cmake
#### Configuring and building
Run the following commands from the `extundeletex-x.y.z` or `ExtundeleteX` directory:
```bash
mkdir build
cd build
cmake ..
make
```
#### Installing
Run the following commands:
```bash
make install
```

#### Example full installation compilation instructions for ExtundeleteX:
```bash
git clone https://github.com/AbysmalBiscuit/ExtundeleteX.git
cd ExtundeleteX
mkdir build
cd build
cmake ..
src/extundelete --help
```

## Usage
To see the various supported options, type:
```bash
extundelete --help
```
### Sample use case scenario
_Note that some of the following commands will require special permissions to complete._  
Adding 'sudo ' before the command is one way to ensure you have the necessary permissions.

Assume you have deleted a file called:
```bash
/home/user/an/important/file
```
Also assume the output of the 'mount' command shows this line (among others):
```bash
/dev/sda3 on /home type ext3 (rw)
```
This line shows that the /home directory is on the partition named `/dev/sda3`, so then run:
```bash
umount /dev/sda3
```
and check that it is now unmounted by running the `mount` command again and seeing it is not listed.
Now, with this information, run `extundelete`:
```bash
extundelete /dev/sda3 --restore-file user/an/important/file
```
If you have deleted the directory 'important', you can run:
```bash
extundelete /dev/sda3 --restore-directory user/an/important
```
Or if you have deleted everything, you can run:
```bash
extundelete /dev/sda3 --restore-all
```

## Notice
I am not the original author of extundelete and have forked it from the [original sourceforge repository](https://sourceforge.net/projects/extundelete/) because it was broken and seemed abandoned.
