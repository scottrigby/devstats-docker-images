wget "${RESTORE_FROM}${PROJDB}.dump" || exit 1
db.sh psql postgres -c "create database $PROJDB" || exit 2
db.sh psql postgres -c "grant all privileges on database \"$PROJDB\" to gha_admin" || exit 3
db.sh psql "$PROJDB" -c "create extension if not exists pgcrypto" || exit 4
db.sh pg_restore -d "$PROJDB" "$PROJDB.dump" || exit 5
rm -f "${PROJDB}" || exit 6
db.sh psql "$PROJDB" -c "delete from gha_vars" || exit 7
GHA2DB_PROJECT="$PROJ" PG_DB="$PROJDB" GHA2DB_LOCAL=1 vars || exit 8
GHA2DB_PROJECT="$PROJ" PG_DB="$PROJDB" GHA2DB_LOCAL=1 GHA2DB_VARS_FN_YAML="sync_vars.yaml" vars || exit 9
GHA2DB_PROJECT=$PROJ PG_DB=$PROJDB ./shared/get_repos.sh || exit 10
GHA2DB_PROJECT="$PROJ" PG_DB="$PROJDB" GHA2DB_LOCAL=1 gha2db_sync || exit 11
./devel/set_flag.sh "$PROJDB" provisioned || exit 12
echo 'OK'
