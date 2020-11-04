# archive-trap

 - Binary name is `trar` (trap archive)
   - Verbs:
     - `pull [host-id]`
     - `push commit-msg`
     - `log [host-id]`
 - Tracks your server configs, based on the hostname
 - Target for pulls and pushes is a _secret_ github repository where
   - Branch names are host names
   - Files are individually encrypted a la `pass` [COMING LATER]
 - Green- / red- lists for configuration files per host are configured in `ArchiveTrap.hs`.
   You can replace it with your own configuration file during build.
   Stock `ArchiveTrap.hs` provides:
   - a default greenlist for the most used configuration files
   - a template for per-host wildcards, greenlists and redlists

## Roadmap

 - JSON over HTTP endpoints for a unified service monitoring web interface
