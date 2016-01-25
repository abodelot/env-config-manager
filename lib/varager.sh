#! /bin/bash

function get_vars {
    app_id=`echo $1 | tr '/' '+'`
    vars=`curl -H "Content-Type: application/json" -H "Authorization: $VARAGER_TOKEN" ${VARAGER_SERVER}/environments/${app_id}.text`

}
function list_vars {
    #   echo endpoint: $VARAGER_SERVER
    #    echo token: $VARAGER_TOKEN
    get_vars $1
    IFS=$'\n'
    for var in $vars; do
    	echo "$var"
    done
}

function export_vars {
    get_vars $1
    IFS=$'\n'
    for var in $vars; do
	echo export "$var"
	export $var
    done

}

case "$1" in
    list)
	list_vars $2
    ;;
    export)
	export_vars $2
    ;;
    *)

        echo "Usage: VARAGER_SERVER=http://varager.api.com VARAGER_TOKEN=auth_token ./varager.sh list ENV"
        exit 64  # EX_USAGE
    ;;
esac
