() {
  typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
    # =========================[ Line #1 ]=========================
    os_icon                 # os identifier
    battery                 # internal battery
    vim_shell               # vim shell indicator (:sh)
    context                 # user@hostname
    disk_usage              # disk usage
    dir                     # current directory
    vcs                     # git status
    # =========================[ Line #2 ]=========================
    newline                 # \n
    prompt_char             # prompt symbol
  )

  typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
    # =========================[ Line #1 ]=========================
    status                  # exit code of the last command
    background_jobs         # presence of background jobs
    # direnv                # direnv status (https://direnv.net/)
    kubecontext             # current kubernetes context (https://kubernetes.io/)
    asdf                    # asdf version manager (https://github.com/asdf-vm/asdf)
    # virtualenv            # python virtual environment (https://docs.python.org/3/library/venv.html)
    # anaconda              # conda environment (https://conda.io/)
    pyenv                   # python environment (https://github.com/pyenv/pyenv)
    # goenv                 # go environment (https://github.com/syndbg/goenv)
    nodenv                  # node.js version from nodenv (https://github.com/nodenv/nodenv)
    # nvm                   # node.js version from nvm (https://github.com/nvm-sh/nvm)
    # nodeenv               # node.js environment (https://github.com/ekalinin/nodeenv)
    # node_version          # node.js version
    # go_version            # go version (https://golang.org)
    # rust_version          # rustc version (https://www.rust-lang.org)
    # dotnet_version        # .NET version (https://dotnet.microsoft.com)
    # php_version           # php version (https://www.php.net/)
    # laravel_version       # laravel php framework version (https://laravel.com/)
    # java_version          # java version (https://www.java.com/)
    # package               # name@version from package.json (https://docs.npmjs.com/files/package.json)
    rbenv                   # ruby version from rbenv (https://github.com/rbenv/rbenv)
    # rvm                   # ruby version from rvm (https://rvm.io)
    # fvm                   # flutter version management (https://github.com/leoafarias/fvm)
    # luaenv                # lua version from luaenv (https://github.com/cehoffman/luaenv)
    jenv                    # java version from jenv (https://github.com/jenv/jenv)
    # plenv                 # perl version from plenv (https://github.com/tokuhirom/plenv)
    # phpenv                # php version from phpenv (https://github.com/phpenv/phpenv)
    # scalaenv              # scala version from scalaenv (https://github.com/scalaenv/scalaenv)
    # haskell_stack         # haskell version from stack (https://haskellstack.org/)
    # terraform             # terraform workspace (https://www.terraform.io)
    # aws                   # aws profile (https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-profiles.html)
    # aws_eb_env            # aws elastic beanstalk environment (https://aws.amazon.com/elasticbeanstalk/)
    # azure                 # azure account name (https://docs.microsoft.com/en-us/cli/azure)
    # gcloud                # google cloud cli account and project (https://cloud.google.com/)
    # google_app_cred       # google application credentials (https://cloud.google.com/docs/authentication/production)
    nordvpn                 # nordvpn connection status, linux only (https://nordvpn.com/)
    # ranger                # ranger shell (https://github.com/ranger/ranger)
    # nnn                   # nnn shell (https://github.com/jarun/nnn)
    # midnight_commander    # midnight commander shell (https://midnight-commander.org/)
    # nix_shell             # nix shell (https://nixos.org/nixos/nix-pills/developing-with-nix-shell.html)
    # vi_mode               # vi mode (you don't need this if you've enabled prompt_char)
    # vpn_ip                # virtual private network indicator
    # load                  # CPU load
    # ram                   # free RAM
    # swap                  # used swap
    # todo                  # todo items (https://github.com/todotxt/todo.txt-cli)
    # timewarrior           # timewarrior tracking status (https://timewarrior.net/)
    # taskwarrior           # taskwarrior task count (https://taskwarrior.org/)
    # time                  # current time
    proxy                   # system-wide http/https/ftp proxy
    command_execution_time  # duration of the last command
    # =========================[ Line #2 ]=========================
    newline                 # \n
    # ip                    # ip address and bandwidth usage for a specified network interface
    # public_ip             # public IP address
    # wifi                  # wifi speed
    # example               # example user-defined segment (see prompt_example function below)
  )

  typeset -g POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR='%016F\uE0B1'

  typeset -g POWERLEVEL9K_RIGHT_SUBSEGMENT_SEPARATOR='%016F\uE0B3'

  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=0

  typeset -g POWERLEVEL9K_DISK_USAGE_ONLY_WARNING=true

  typeset -g POWERLEVEL9K_BATTERY_HIDE_ABOVE_THRESHOLD=30

  (( ! $+functions[p10k] )) || p10k reload
}
