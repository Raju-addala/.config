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
emergency_alarm(){
    for i in {1..10};
    do
        alarm
    done
}
checkping(){
    checktask "ping -o $1 |head -5|egrep ttl" "IP is online"
}
checknotping(){
    checktask "ping -o $1 |head -5|egrep timeout" "IP is offline"
}

checktask(){
    x=`eval $1`
    message=${2:-"None"}
    while [[ `echo $x | wc -c` -le 1 ]]
    do
        x=`eval $1`
        echo "checktask: $1 , output: **$x** end"
        date
        sleep 5
    done
    echo "checktask: $1 , output: **$x** end"
    if [[ $message == "None" ]]
    then 
        alarm
    else
        say $message
    fi
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

get_charge(){
    system_profiler SPPowerDataType | grep "State of Charge" | awk '{print $5}'
}

start_charge_at(){
    desired_chg=$1
    current_chg=100
    while [[ $current_chg -gt $desired_chg ]]
    do
        current_chg=`get_charge`
        echo "charging: $current_chg"
        sleep 10
    done
    say "Charge is $current_chg"
}


stop_charge_at(){
    desired_chg=$1
    current_chg=0
    while [[ $current_chg -lt $desired_chg ]]
    do
        current_chg=`get_charge`
        echo "charging: $current_chg"
        sleep 10
    done
    say "Charge is $current_chg"
}

ist_to_cest(){
    IST_TIME=$1
    IST_HOUR=$(echo $IST_TIME | cut -d: -f1)
    IST_MIN=$(echo $IST_TIME | cut -d: -f2)
    
    # IST is UTC+5:30 and CEST is UTC+2
    OFFSET_HOURS=$(( -5 + 2 ))
    OFFSET_MINS=$(( -30 ))
    
    CEST_MIN=$(( IST_MIN + OFFSET_MINS ))
    if [[ $CEST_MIN -ge 60 ]]; then
        CEST_MIN=$((CEST_MIN - 60))
        IST_HOUR=$((IST_HOUR + 1))
    fi
    
    CEST_HOUR=$(( IST_HOUR + OFFSET_HOURS ))
    if [[ $CEST_HOUR -ge 24 ]]; then
        CEST_HOUR=$((CEST_HOUR - 24))
        DAY_OFFSET=1
    elif [[ $CEST_HOUR -lt 0 ]]; then
        CEST_HOUR=$((CEST_HOUR + 24))
        DAY_OFFSET=-1
    else
        DAY_OFFSET=0
    fi
    
    CEST_TIME=$(printf "%02d:%02d" $CEST_HOUR $CEST_MIN)
    
    case $DAY_OFFSET in
        0) echo "$CEST_TIME today" ;;
        1) echo "$CEST_TIME tomorrow" ;;
        -1) echo "$CEST_TIME yesterday" ;;
    esac
}

cest_to_ist(){
    CEST_TIME=$1
    CEST_HOUR=$(echo $CEST_TIME | cut -d: -f1)
    CEST_MIN=$(echo $CEST_TIME | cut -d: -f2)
    
    # IST is UTC+5:30 and CEST is UTC+2
    OFFSET_HOURS=$(( 5 - 2 ))
    OFFSET_MINS=$(( 30 ))
    
    IST_MIN=$(( CEST_MIN + OFFSET_MINS ))
    if [[ $IST_MIN -ge 60 ]]; then
        IST_MIN=$((IST_MIN - 60))
        CEST_HOUR=$((CEST_HOUR + 1))
    fi
    
    IST_HOUR=$(( CEST_HOUR + OFFSET_HOURS ))
    if [[ $IST_HOUR -ge 24 ]]; then
        IST_HOUR=$((IST_HOUR - 24))
        DAY_OFFSET=1
    elif [[ $IST_HOUR -lt 0 ]]; then
        IST_HOUR=$((IST_HOUR + 24))
        DAY_OFFSET=-1
    else
        DAY_OFFSET=0
    fi
    
    IST_TIME=$(printf "%02d:%02d" $IST_HOUR $IST_MIN)
    
    case $DAY_OFFSET in
        0) echo "$IST_TIME today" ;;
        1) echo "$IST_TIME tomorrow" ;;
        -1) echo "$IST_TIME yesterday" ;;
    esac
}