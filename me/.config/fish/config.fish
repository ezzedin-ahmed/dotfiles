if status is-interactive
    # Commands to run in interactive sessions can go here
    fish_config theme choose "Catppuccin"

    # Java (SDKMAN JDK 21)
    set -gx JAVA_HOME "$HOME/.sdkman/candidates/java/current"

    # Android SDK
    set -gx ANDROID_HOME "$HOME/Android/Sdk"
    set -gx ANDROID_SDK_ROOT "$HOME/Android/Sdk"

    # PNPM
    set -gx PNPM_HOME "$HOME/.local/bin"

    # Kube
    set -gx KUBECONFIG "$HOME/.kube/config"

    # LaTeX
    set -gx TEXMFHOME "$HOME/texmf"

    # PATH
    fish_add_path "$HOME/.local/bin"
    fish_add_path "$HOME/.local/share/pnpm"
    fish_add_path "$JAVA_HOME/bin"
    fish_add_path "$HOME/.sdkman/candidates/kotlin/current/bin"
    fish_add_path "$HOME/.sdkman/candidates/gradle/current/bin"
    fish_add_path "$ANDROID_HOME/cmdline-tools/latest/bin"
    fish_add_path "$ANDROID_HOME/platform-tools"
    fish_add_path "$ANDROID_HOME/emulator"
    fish_add_path "/var/android-studio/bin"
    alias ls eza
    alias k "sudo kubectl"
end
