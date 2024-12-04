source .env
now=$(date +"%s_%Y-%m-%d")
docker run     --rm --entrypoint "" --network git_backend     -v /opt/backup:/backup     --link="mysqlbackup"     schnitzler/mysqldump     mysqldump --opt -h 172.20.0.10 -u ${USERNAME} -p ${PASSWORD} "--result-file=/backup/${now}virtd.sql" virtd