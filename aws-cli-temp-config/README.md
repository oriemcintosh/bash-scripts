# Overview

This directory houses two scripts, a setup script and a script to assist in loading temporary AWS CLI credentials into shell environment variables.

> :loudspeaker: **Important**
> These scripts assume you are using `zsh` as your shell. Updates will be made for other default shells.


1. Run the setup script (`setup.sh`), which will make the necessary configurations to the `awsclienvvars.sh` script and place it into a directory that is already within your PATH for future execution. The binary location being used by the script will be `/usr/local/bin`, so the script will issue a `sudo` command to perform the `mv` of the script file and request your password. In addition to this, the setup will request a name for the alias to execute the script when you need it from your shell.

2. Reset your shell by opening another terminal window or issuing the command: `source ~/.zshrc`
