# 1. Set JAVA_HOME (Use the actual Java installation path)
set -gx JAVA_HOME /usr/lib/jvm/default

# 2. Set ANDROID_HOME (Arch's default for AUR packages)
set -gx ANDROID_HOME /opt/android-sdk

# 3. Add Java and Android SDK tools to PATH (Java first!)
set -gx PATH $JAVA_HOME/bin $PATH
set -gx PATH $ANDROID_HOME/platform-tools $PATH
set -gx PATH $ANDROID_HOME/cmdline-tools/latest/bin $PATH
set -gx PATH $ANDROID_HOME/tools $PATH
set -gx PATH $ANDROID_HOME/emulator $PATH
