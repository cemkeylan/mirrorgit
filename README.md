# Git Mirroring Script

Setting up a git mirror is hard, especially if you are trying to mirror your repository to Microsoft's Github. Microsoft does not want you to self-host, so they don't present you with any options for mirroring.

This little shell script:
* Fetches the repositories to a temporary directory
* Pushes them to the mirror repository

It is pretty simple.

## Usage

```shell
sh mirrorgit.sh
```

The script creates a file on your home directory to save configuration

The file can be located and be edited in ~/.mirrorgitrc

## Dependencies
* Git (obviously)
* SSH keys deployed on the mirror repository
