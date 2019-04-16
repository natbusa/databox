#!/bin/bash
set -Eeo pipefail
export PATH=$PATH:/opt/mssql/bin:/opt/mssql-tools/bin

# if command starts with an option, prepend sqlservr
if [ "${1:0:1}" = '-' ]; then
    set -- sqlservr "$@"
fi
CMD="$@"

# usage: file_env VAR [DEFAULT]
#    ie: file_env 'XYZ_DB_PASSWORD' 'example'
# (will allow for "$XYZ_DB_PASSWORD_FILE" to fill in the value of
#  "$XYZ_DB_PASSWORD" from a file, especially for Docker's secrets feature)
file_env() {
    local var="$1"
    local fileVar="${var}_FILE"
    local def="${2:-}"
    if [ "${!var:-}" ] && [ "${!fileVar:-}" ]; then
        echo >&2 "error: both $var and $fileVar are set (but are exclusive)"
        exit 1
    fi
    local val="$def"
    if [ "${!var:-}" ]; then
        val="${!var}"
    elif [ "${!fileVar:-}" ]; then
        val="$(< "${!fileVar}")"
    fi
    export "$var"="$val"
    unset "$fileVar"
}

# usage: process_init_file FILENAME COMMAND...
#    ie: process_init_file foo.sh sqlcmd -U SA
# (process a single initializer file, based on its extension. we define this
# function here, so that initializer scripts (*.sh) can use the same logic,
# potentially recursively, or override the logic used in subsequent calls)
process_init_file() {
    local f="$1"; shift
    local sqlcmd=( "$@" )

    case "$f" in
        *.sh)     echo "$0: running $f"; . "$f" ;;
        *.sql)    echo "$0: running $f"; "${sqlcmd[@]}" -i "$f"; echo ;;
        *.sql.gz) echo "$0: running $f"; gunzip -c "$f" | "${sqlcmd[@]}"; echo ;;
        *)        echo "$0: ignoring $f" ;;
    esac
    echo
}

mssql_init() {
    echo "Microsoft SQL Server initializing database"
    DATADIR=/var/opt/mssql/data
    sqlcmd=( sqlcmd -U sa -P "${MSSQL_SA_PASSWORD}" )

    if [ -d "$DATADIR" ]; then
        return
    fi
    mkdir -p "$DATADIR"

    # startup first time setup
    "$CMD" &
    pid="$!"
    for i in {30..0}; do
        if "${sqlcmd[@]}" -Q 'SELECT 1;' &> /dev/null; then
            break
        fi
        echo "Microsoft SQL Server startup in progress..."
        sleep 1
    done
    if [ "$i" = 0 ]; then
        echo >&2 'Microsoft SQL Server init process failed.'
        exit 1
    fi

    # run init files
    for f in /docker-entrypoint-initdb.d/*; do
        process_init_file "$f" "${sqlcmd[@]}"
    done

    # teardown first time setup
    if ! kill -s TERM "$pid" || ! wait "$pid"; then
        echo >&2 'Microsoft SQL Server init process failed.'
        exit 1
    fi

    echo
    echo 'Microsoft SQL Server init process done. Ready for start up.'
    echo
}

if [[ "$1" =~ ^(.*/)?sqlservr$ ]]; then
    mssql_init
fi

exec "$CMD"
