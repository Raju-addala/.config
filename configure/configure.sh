BASEDIR=$(dirname "$(realpath  $0)")

# check if CONFIGURE_DIR env exists
if [ -z "$CONFIGURE_DIR" ]
then
    echo 'export CONFIGURE_DIR="'${BASEDIR}'"' >> ~/.mysetup.sh
fi

file_name="configure.sh"

if [ "$OSTYPE" = "linux-gnu"* ]
then
        # ...
    sudo apt update
elif [ "$OSTYPE" = "darwin"* ]
then
    if ! (command -v brew)
    then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    else
        echo "brew is already installed"
    fi
    echo "mac"
fi

$BASEDIR/zsh/${file_name}
$BASEDIR/vim/${file_name}
$BASEDIR/clang/${file_name}
