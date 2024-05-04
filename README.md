# zsh-color-logging
provides a really easy to use logging library with notifications for pushbullet and pushover\\
colorize various tools like tail head cat\
also provides a color library

#ewarn "this is a warning"\
#eerror "this is an error"\
#einfo "this is an information"\
#edebug "debugging"\
#ecrit "CRITICAL MESSAGE!"\
#edumpvar HOSTNAME

![image](https://github.com/p1r473/zsh-color-logging/assets/9235633/b3835248-ac46-4be9-9004-1a89bb4dfb89)

### zinit

```zsh
zinit wait lucid for p1r473/zsh-color-logging
```

### Zplug

```zsh
zplug "p1r473/zsh-color-logging"
```

### Antigen

```zsh
antigen bundle p1r473/zsh-color-logging
```

### Oh-My-Zsh

```zsh
git clone https://github.com/p1r473/zsh-color-logging.git $ZSH_CUSTOM/plugins/zsh-color-logging
```

```zsh
plugins=(
  #...
  zsh-color-logging
  )
```

### Manual

```zsh
git clone https://github.com/p1r473/zsh-color-logging $ZSH_CUSTOM/plugins
source $ZSH_CUSTOM/plugins/zsh-colorize/zsh-color-logging/zsh-color-logging.plugin.zsh
```
