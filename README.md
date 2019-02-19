# bibtex

This repository contains a bibtex file and resources for citing Phil McMinn's papers.

## Installation Instructions
The repository should be used as a git submodule of 
another repository. To do this, type the following command:

```shell
git submodule add -b master https://github.com/philmcminn/mypubs.git mypubs
```

where the final parameter ("bibtex") is the name of the directory that you wish to install the repository. Following
this, you will need to invoke the following commands:

```shell
git submodule init
git submodule update
```

Of course, the submodule will need to be pulled periodically to receive any changes. This can be done by changing
directory to the submodule and issue the usual ``git pull``. (If Git has detached the submodule from its HEAD, it
may be reattached by issuing the command ``git checkout master`` from the submodule's directory.

Another means of ensuring the submodule is updated when pulling from the main repository is to issue the following
command, which will also update all submodules:

```shell
git pull --recurse-submodules
```
