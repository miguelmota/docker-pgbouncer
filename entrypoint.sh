#!/bin/bash

set -e

bash -c "/usr/local/bin/confd -onetime -backend env"

bash -c "exec pgbouncer -u pgbouncer /etc/pgbouncer/pgbouncer.ini"
