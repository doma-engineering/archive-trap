# archive-trap

 - Hacky way to make a snapshot:
   - Configure your stuff in `src/ArchiveTrap.hs`:
     - Choose computer type ("laptop" by default)
     - Change secure git repo to your config storage
     - Make sure there are no creds in your `.fetchmailrc` (they MUST be in `.netrc`)
     - Run a command akin to this:

```
# Do this step once
sudo su
git config --global user.name "root"
git config --global user.email "root@localhost"
exit

# Do this step to run backup
stack build --copy-bins && \
  sudo rm -rvf "/tmp/archive-trap-secure/" ; sudo cp -rv "$HOME/.ssh" "/root/" && \
  sudo "$HOME/.local/bin/archive-trap-exe"

# Explanation:
 # stack build --copy-bins: Will copy `archive-trap-exe` into your ~/.local/bin
 # rm -rvf /tmp/archive-trap-secure/: Will make sure you don't have
   # secure repo cloned anymore
 # cp -rv "$HOME/.ssh" "/root/": Will copy your private key to root home
   # directory (I assume that your threat model is such that if root is
   # compromised your user is also compromised, so it's fine. Just don't
   # forget about this bit if you have some scripts to wipe your private
   # info from a computer quickly)
 # sudo "$HOME/.local/bin/archive-trap-exe": Actually runs the backup
   # script. Sudo is needed to grab configs from other users if needed.

```

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
