# docker-pgbouncer

> Dockerfile for running [pgbouncer](https://github.com/pgbouncer/pgbouncer)

## Setup


```
git clone git@github.com:miguelmota/docker-pgbouncer.git
cd docker-pgbouncer
cp env.list.sample env.list
```

`env.list` should contain the following environment variables

- `POSTGRES_HOST`
- `POSTGRES_PORT`
- `POSTGRES_USER`
- `POSTGRES_PASS`

## Build

```bash
docker build -t pgbouncer --no-cache .
```

## Run

```bash
docker run --env-file=env.list pgbouncer
```

## Connect

Connect to pgbouncer proxied database

```bash
PGPASSWORD=<pg_password> psql -h <docker_ip> -p 6432 -U <pg_username> <pg_dbname>
```

## Resources

- [PgBouncer documentation](https://github.com/pgbouncer/pgbouncer)

## License

MIT
