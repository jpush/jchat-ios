#! /bin/sh

############################
# Check version of JMessage.framework dir in root whether it is fit to the definition in JMESSAGE_VERSION file
# if buildId in JMESSAGE_VERSOIN file is equals to  ~, then ignore it
#########

echo "Action - check_jmessage_version"

if [ ! -f JMESSAGE_VERSION ]; then
    echo "JMESSAGE_VERSION file not exists. It is not in JChat project root dir? "
    exit 1
fi

if [ ! -d "JMessage.framework" ]; then
    echo "JMessage.framework dir not exists. It is not in JChat proejct root dir? "
    exit 1
fi

# Fetch version & buildId form JMESSAGE_VERSION file
while IFS='=' read -r KEYS VALUES || [[ -n "$KEYS" ]]; do
    if [ "${KEYS}" = "JMESSAGE_VERSION" ]; then
        version="$VALUES"
    elif [ "${KEYS}" = "JMESSAGE_BUILD" ]; then
        buildId="$VALUES"
    fi
done < JMESSAGE_VERSION

echo "Fetched from JMESSAGE_VERSION file - version:$version, buildId:$buildId"

# Fetch version & buildId from JMessage.framework header file

JMESSAGE_H_FILE="JMessage.framework/Headers/JMessage.h"

if [ ! -f $JMESSAGE_H_FILE ]; then
    echo "JMessage.h file not exists as expected. "
    exit 1
fi


VERSION_LINE=`grep -o '^#define JMESSAGE_VERSION @\"[0-9.]*\"$' $JMESSAGE_H_FILE`
if [ ! "$VERSION_LINE" ]; then
    echo "Not found version definition. "
    return 1
fi
headerVersion=`echo $VERSION_LINE | awk -F \" '{print $2}'`

BUILDID_LINE=`grep -o '^#define JMESSAGE_BUILD [0-9.]*' $JMESSAGE_H_FILE`
if [ ! "$BUILDID_LINE" ]; then
    echo "Not found buildId definition. "
    return 1
fi
headerBuildId=`echo $BUILDID_LINE | awk '{print $3}'`

echo "Fetched from JMessage.framework header file - version:$headerVersion, buildId:$headerBuildId"


if [ ! $version = $headerVersion ]; then
    echo "jmessage version does not match. "
    exit 1
fi

if [ $buildId = "~" ]; then
    echo "Ignore buildId match. "
    exit 0
fi

if [ ! $buildId = $headerBuildId ]; then
    echo "jmessage buildId does not match. "
    exit 1
fi


