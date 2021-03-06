if [ "$ServerName" = "" ]; then
    export ServerName=`echo $PodName | awk -F- '{print $2}'`
fi

export APP_DATA_DIR=/usr/local/app/tars/tarsnode/data/${ServerApp}.${ServerName}
export APP_LOG_DIR=/usr/local/app/tars/app_log/${ServerApp}/${ServerName}

alias cdl="cd $APP_LOG_DIR"
alias cdd="cd $APP_DATA_DIR"
alias taila="tail -f $APP_LOG_DIR/access.json"
alias taild="tail -f $APP_LOG_DIR/default.log"
alias tailc="tail -f $APP_LOG_DIR/tars-client.json"
alias taile="tail -f $APP_LOG_DIR/error.log"
alias tails="tail -f $APP_LOG_DIR/tars-server.json"
