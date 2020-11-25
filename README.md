# archive-trap

 - Hacky way to make a snapshot:
   - Configure your stuff in `src/ArchiveTrap.hs`:
     - Choose computer type ("laptop" by default)
     - Change secure git repo to your config storage
     - Make sure there are no creds in your `.fetchmailrc` (they MUST be
       in `.netrc`
     - Run a command akin to this:

```
sudo su
git config --global user.name "root"
git config --global user.email "root@localhost"
exit
stack build && sudo rm -rvf /tmp/archive-trap-secure/ && sudo cp -rv
~/.ssh /root/ && sudo
.stack-work/dist/x86_64-linux-tinfo6/Cabal-3.0.1.0/build/archive-trap-exe/archive-trap-exe
```
   - `stack build`: rebuild the project with your new configuration
   - `sudo cp -rv ~/.ssh ...`: make sure `root` can pull from Git
   - `sudo .stack-work ...`: run archive trap. Sudo needed to capture other people's home directories.

## What is this

 - _archive-trap_ tracks your server and personal computer configs, based on the hostname
 - Target for pulls and pushes is a _secret_ github repository where
   - Branch names are host names prefixed with computer types
 - Green- / red- lists for configuration files per host are configured in `ArchiveTrap.hs`.
   You can replace it with your own configuration file during build.
   Stock `ArchiveTrap.hs` provides:
   - a default greenlist for the most used configuration files
   - a template for per-host wildcards, greenlists and redlists


## Roadmap

 - Set binary name to `cfg`
 - Use `rsync` as backend for local copies
 - Implement Verbs:
    - `--pull [host-id]`
    - `--push commit-msg`
    - `--snap [host-id]`

## Further roadmap

 - Commit individual files from CLI
 - List all the occurrences of individual file / directory (across known configs)
 - Files are individually encrypted a la `pass`
 - Encrypt whole branches with `tomb`
 - JSON over HTTP endpoints for a unified service monitoring web interface
 - Generate SimpleInclude|Exclude with TH
