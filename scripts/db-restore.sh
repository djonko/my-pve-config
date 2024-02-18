psql -U $(< /run/secrets/POSTGRES_USER) $(< /run/secrets/POSTGRES_DB) < dump_name.sql
mariadb -u root --password=$(< /run/secrets/MYSQL_ROOT_PASSWORD) < dump_name.sql