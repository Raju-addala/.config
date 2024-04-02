# check if zsh exists

# exit if command is not installed
fatal_check_command(){
    ( ! command -v $1 &> /dev/null ) && (echo "$1 is not installed" ; exit )
}

BASEDIR=$(dirname "$(realpath  $0)")

# check if curl exists

if ! (command -v curl)
then
    # install curl
    echo "installing curl"
    sudo apt install curl

    fatal_check_command curl
else
    echo "curl is already installed"
fi

if ! (command -v zsh)
then
    # install zsh
    echo "installing zsh"
    sudo apt install zsh

    fatal_check_command zsh

    echo zsh is installed, configure in next session
else
    echo "zsh is already installed"
fi

# Check if oh-my-zsh is already installed
if [ -d "$HOME/.oh-my-zsh" ]; then
    echo "oh-my-zsh is already installed."
else
    # Install oh-my-zsh: https://ohmyz.sh
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

    # Install Powerlevel10k: https://github.com/romkatv/powerlevel10k
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
    echo 'export ZSH_THEME="powerlevel10k/powerlevel10k"' >> ~/.zshrc

    p10k configure

    # install auto-suggestions
    git clone https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions 
    # install syntax highlighting
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
fi

ln -sfn ${BASEDIR}/.my_zsh_rc ~/.zshrc


# install fd

# check if fd exists

if ! (command -v fd)
then
    # install fd
    echo "installing fd"
    curl -L https://github.com/sharkdp/fd/releases/download/v8.4.0/fd-musl_8.4.0_amd64.deb -o fd-musl_8.4.0_amd64.deb
    sudo dpkg -i fd-musl_8.4.0_amd64.deb
    fatal_check_command fd
else
    echo "fd is already installed"
fi

