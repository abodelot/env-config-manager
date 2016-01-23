#! /bin/bash

function list_vars {
 #   echo endpoint: $VARAGER_SERVER
#    echo token: $VARAGER_TOKEN
    app_id=`echo $1 | tr '/' '+'`
    echo app_id: $app_id
    vars=`curl -H "Content-Type: application/json" -H "Authorization: $VARAGER_TOKEN" ${VARAGER_SERVER}/environments/${app_id}.text`
    for var in $vars; do
	echo $var
    done

}

function export_vars {
	list_vars $1
    for var in $vars; do
	echo export $var
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
