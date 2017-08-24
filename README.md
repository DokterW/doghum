# Dokter's GitHub Manager

A (pseudo) packet manager for rpms hosted on GitHub and Dokter's bash scripts.

Which is the gist of what this bash script is.

It works like most CLI packet managers.

I made this for two reasons.

1. I was considering making a script to install my scripts so I would not need to run them from the production folder. That script would of course be local, so why not make it so anyone could install my scripts more easily.

2. I already had a script to install and upgrade [Atom](https://www.atom.io). Again, why not incorporate it.

The main focus on this script will be for my scripts and software that is available via github but not available in any conventional repo.

*At the moment I am not taking requests for software to be added.*

The software lists will be fetched directly from this github repo and will therefore be updated without the need of the main script to be updated. Nor any need to continuesly download the list to your computer.

## How to use it

**doghum <command> [<arg>]**

*Available commands*

* install
* upgrade
* remove
* list

By only running *doghum* it will show above list of commands.

### Roadmap

* Add description to *list* command.
* Make removal of scripts safer.
* Add the ability to add your own, local repos.

### Changelog

#### 2017-08-24
* Rewritten the code a bit for better error handling.

#### 2017-04-23
* Reloads .bashrc when installing a new bash script.
