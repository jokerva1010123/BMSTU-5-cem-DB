#!/bin/bash

set -x

python3 generate.py

psql -c "\i create.sql"
psql -c "\i constraint.sql"
psql -c "\i copy.sql"
