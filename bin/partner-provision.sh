#!/bin/sh

# accepts: partner client ID and secret key
# executes wp-cli command to provision Jetpack site for given partner

function usage
{
    echo "Usage: partner-provision.sh --client_id=client_id --client_secret=client_secret --plan=plan_name"
}

for i in "$@"; do
    key="$1"
    echo $i
    case $i in
        -c=* | --client_id=* )      CLIENT_ID="${i#*=}"
                                    shift
                                    ;;
        -s=* | --client_secret=* )  CLIENT_SECRET="${i#*=}"
                                    shift
                                    ;;
        -p=* | --plan=* )           PLAN_NAME="${i#*=}"
                                    shift
                                    ;;
        -h | --help )               usage
                                    exit
                                    ;;
        * )                         usage
                                    exit 1
    esac
    shift
done

if [ "$CLIENT_ID" = "" ] || [ "$CLIENT_SECRET" = "" ] || [ "$PLAN_NAME" = "" ]; then
    usage
    exit
fi

echo "Success - client = $CLIENT_ID, secret = $CLIENT_SECRET, plan = $PLAN_NAME";

ACCESS_TOKEN_JSON=`$( printf "curl https://public-api.wordpress.com/oauth2/token --silent -d \"grant_type=client_credentials&client_id=%q&client_secret=%q&scope=jetpack-partner\"" $CLIENT_ID $CLIENT_SECRET )`
echo $ACCESS_TOKEN_JSON

# TODO: 
# - execute wp-cli script to provision site and plan
# - pass back any errors, or if successful a "next" URL for the user to finish provisioning their plan

