psql -U $(< /run/secrets/POSTGRES_USER) $(< /run/secrets/POSTGRES_DB) < dump_name.sql
