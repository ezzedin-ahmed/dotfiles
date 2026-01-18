if status is-interactive
    # Commands to run in interactive sessions can go here
    fish_config theme choose "Catppuccin"
    set JAVA_HOME "/var/amazon-corretto-17.0.16.8.1-linux-x64"
    set PATH "$HOME/.local/bin:$PATH"
    set PATH "$HOME/.local/share/pnpm:$PATH"
    set PATH "$JAVA_HOME/bin:$PATH"
    set PNPM_HOME "$HOME/.local/bin"
    set KUBECONFIG "$HOME/.kube/config"
    alias ls eza
end
