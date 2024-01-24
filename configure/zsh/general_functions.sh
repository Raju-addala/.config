is_bash=0
if [[ $SHELL == *"bash" ]]
then
  is_bash=1
fi

beep(){
    echo -e "\a"
}

alarm(){
    beep; sleep 0.5; beep; sleep 0.5; beep;
    sleep 1;
    beep; sleep 0.5; beep;
    sleep 1;
    beep;
}
checkping(){
    checktask "ping -o $1 |head -5|egrep ttl"
}
checknotping(){
    checktask "ping -o $1 |head -5|egrep timeout"
}

checktask(){
    x=`eval $1`
    while [[ `echo $x | wc -c` -le 1 ]]
    do
        x=`eval $1`
        echo "checktask: $1 , output: **$x** end"
        date
        sleep 5
    done
    echo "checktask: $1 , output: **$x** end"
    alarm
}


searchbrowser(){
    open http://www.google.com/search?q=$1
}


aliascp()
{
    [[ `alias $1` =~ \'(.*)\' ]]
    echo -n ${match[1]} | pbcopy 
}

cscope_refresh(){
    CSCOPE_DIR="$PWD/cscope"
    
    if [ ! -d "$CSCOPE_DIR" ]; then
    mkdir "$CSCOPE_DIR"
    fi
    
    echo "Finding files ..."
    fd -e c -e cpp -e h -e hpp -e py --base-directory $PWD > "$CSCOPE_DIR/cscope.files"
    
    echo "Adding files to cscope db: $PWD/cscope.db ..."
    cscope -b -q -k "$CSCOPE_DIR/cscope.files"
    
    export CSCOPE_DB="$PWD/cscope.out"
    echo "Exported CSCOPE_DB to: '$CSCOPE_DB'"
}
