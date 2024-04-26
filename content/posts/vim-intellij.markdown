title: Opening intellij source in vim
slug: intellij-vim
category: computing
date: 2019-05-09
modified: 2019-05-09
<!-- Status: draft -->

Terminal Emulator: rxvt

## Location of URXVT

### In nixos

```bash
/run/current-system/sw/bin/urxvt
```

### In ubuntu

```bash
/usr/bin/urxvt
```

```bash
-e sh -c "vim --servername "intellij" --remote +$LineNumber$ $FilePath$"
```

```bash
$ProjectFileDir$
```
