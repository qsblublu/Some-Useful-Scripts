#!/bin/bash
# upload/download file or dir to/from remote server


# config name to ip
ali="123.57.128.111"


DEBUG=0
# exit code
NO_COMMAND=127
SUCC_END=0


# usage and some error info
USAGE="
    this script use 'scp' to transmit file.\n\n
    usage: transmitf [options] command\n\n
    command:\n
        \tdownload: download file or dir from remote server\n
        \tupload: upload file or dir to remote server\n\n
    options:\n
        \t-p port\n
        \t-u user\n
        \t--host=host\n
        \t--lp=local path\n
        \t-sp=server path\n
        \t-h\n
    "

ERROR_COMMAND="unsupported command."

ERROR_OPTION="unsupported option."


tmp=$(getopt -n $0 -u -o p:u:h -l host:,lp:,sp: -- "$@")
set -- $tmp

if [ $DEBUG -eq 1 ]; then
    echo $tmp
fi

# script
cmd_str="scp "
command=""
local_path=""
server_path=""
scp_opt="-r "
user=""
host=""
space=" "


function handle_error_command () {
    if [ $command != "upload" ] && [ $command != "download" ] && [ $DEBUG -eq 0 ]; then
        echo -e $ERROR_COMMAND
        echo -e $USAGE
        exit $NO_COMMAND
    fi
}


function handle_error_option () {
    if [ -z $1 ] && [ $DEBUG -eq 0 ]; then
        echo -e $ERROR_OPTION
        echo -e $USAGE
        exit $NO_COMMAND
    fi
}


while [ -n $1 ]; do
    case "$1" in
        -p)
            handle_error_option $2
            scp_opt=$scp_opt$1$space$2
            shift                    
        ;;
        -h)
            echo -e $USAGE
            shift
            exit $SUCC_END
        ;;
        -u)
            handle_error_option $2
            user=$2
            shift
        ;;
        --host)
            handle_error_option $2
            host=$2
            shift
        ;;
        --lp)
            handle_error_option $2
            local_path=$2
            shift
        ;;
        --sp)
            handle_error_option $2
            server_path=$2
            shift
        ;;
        --)
            shift
            break
        ;;
    esac
    shift
done


command=$1
handle_error_command


if [ $command == "upload" ]; then
    cmd_str=$cmd_str$scp_opt$space$local_path$space$user"@"${!host}":"$server_path
else
    cmd_str=$cmd_str$scp_opt$space$user"@"${!host}":"$server_path$space$local_path
fi

if [ $DEBUG -eq 1 ]; then
    echo "command: "$command
    echo "scp_opt: "$scp_opt
    echo "user: "$user
    echo "host: "$host
    echo "sp: "$server_path
    echo "lp: "$local_path
    echo "cmd: "$cmd_str
else
    `$cmd_str`
fi
