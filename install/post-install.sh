#!/bin/sh

# macup does not support xdg yet
ln -sfn ~/.config/mackup/.mackup.cfg ~
mackup restore

#jenv
jenv add /Library/Java/JavaVirtualMachines/adoptopenjdk-11.jdk/Contents/Home/
jenv add /Library/Java/JavaVirtualMachines/adoptopenjdk-8.jdk/Contents/Home/

# fzf
"$(brew --prefix)/opt/fzf/install"
