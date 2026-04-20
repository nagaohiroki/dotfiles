# env.nu
#
# Installed by:
# version = "0.112.2"
#
# Previously, environment variables were typically configured in `env.nu`.
# In general, most configuration can and should be performed in `config.nu`
# or one of the autoload directories.
#
# This file is generated for backwards compatibility for now.
# It is loaded before config.nu and login.nu
#
# See https://www.nushell.sh/book/configuration.html
#
# Also see `help config env` for more options.
#
# You can remove these comments if you want or leave
# them for future reference.
if ($nu.os-info.name == "macos") {
    $env.PATH = ($env.PATH | split row (char esep) | prepend ($env.HOME | path join ".local" "bin"))
    $env.PATH = ($env.PATH | prepend "/opt/homebrew/bin")
    $env.HOMEBREW_PREFIX = "/opt/homebrew"
}