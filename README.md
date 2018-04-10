# docker-pgbouncer

> Dockerfile for running [pgbouncer](https://github.com/pgbouncer/pgbouncer)

## Build

```bash
docker build -t pgbouncer --no-cache .
```

## Run

```bash
docker run --env-file=env.list pgbouncer
```

`env.list` should contain the following environment variables

- `POSTGRES_HOST`
- `POSTGRES_PORT`
- `POSTGRES_USER`
- `POSTGRES_PASS`

```bash
PGPASSWORD=<pg_password> psql -h <docker_ip> -p <pg_port> -U <pg_username> <pg_dbname>
```

## Resources

- [PgBouncer documentation](https://github.com/pgbouncer/pgbouncer)

## License

MIT
