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
.stack-work/dist/x86_64-linux-tinfo6/Cabal-3.0.1.0/build/archive-trap-exe/archive-trap-exe```

      - `stack build`: rebuild the project with your new configuration
      - `sudo cp -rv ~/.ssh ...`: make sure `root` can pull from Git
      - `sudo .stack-work ...`: run archive trap. Sudo needed to capture
        other people's home directories.

## Roadmap

 - Binary name is `cfg` (confusing the audience)
   - Verbs:
     - `--pull [host-id]`
     - `--push commit-msg`
     - `--snap [host-id]`
 - Tracks your server configs, based on the hostname
 - Target for pulls and pushes is a _secret_ github repository where
   - Branch names are host names
   - Files are individually encrypted a la `pass` [COMING LATER]
 - Green- / red- lists for configuration files per host are configured in `ArchiveTrap.hs`.
   You can replace it with your own configuration file during build.
   Stock `ArchiveTrap.hs` provides:
   - a default greenlist for the most used configuration files
   - a template for per-host wildcards, greenlists and redlists

## Further roadmap

 - Commit individual files
 - List all the occurrences of individual file / directory (across known
   configs)
 - Files are individually encrypted a la `pass` [COMING LATER]
 - JSON over HTTP endpoints for a unified service monitoring web interface
 - Generate SimpleInclude|Exclude with TH
