BASEDIR=$(dirname "$(realpath  $0)")

ln -sfn ${BASEDIR}/.clang-format ~/.clang-format
ln -sfn ${BASEDIR}/.clang-tidy ~/.clang-tidy
