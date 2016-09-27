#!/bin/bash
DB_VERSION=10.3
docker cp em:/opt/CA/Introscope/install/database-scripts/add-apm-constraints-postgres-${DB_VERSION}.0.0.sql .
docker cp em:/opt/CA/Introscope/install/database-scripts/add-apm-indexes-postgres-${DB_VERSION}.0.0.sql .
docker cp em:/opt/CA/Introscope/install/database-scripts/addconstraints-postgres-${DB_VERSION}.0.0.sql .
docker cp em:/opt/CA/Introscope/install/database-scripts/addindexes-postgres-${DB_VERSION}.0.0.sql .
docker cp em:/opt/CA/Introscope/install/database-scripts/addviews-postgres-${DB_VERSION}.0.0.sql .
docker cp em:/opt/CA/Introscope/install/database-scripts/apm-defaults-postgres-${DB_VERSION}.0.0.sql .
docker cp em:/opt/CA/Introscope/install/database-scripts/apm-procedures-postgres-${DB_VERSION}.0.0.sql .
docker cp em:/opt/CA/Introscope/install/database-scripts/create-apm-sequences-postgres-${DB_VERSION}.0.0.sql .
docker cp em:/opt/CA/Introscope/install/database-scripts/create-apm-tables-postgres-${DB_VERSION}.0.0.sql .
docker cp em:/opt/CA/Introscope/install/database-scripts/createsequences-postgres-${DB_VERSION}.0.0.sql .
docker cp em:/opt/CA/Introscope/install/database-scripts/createtables-postgres-${DB_VERSION}.0.0.sql .
docker cp em:/opt/CA/Introscope/install/database-scripts/dbupdate-apm-sequences-postgres-${DB_VERSION}.0.0.sql .
docker cp em:/opt/CA/Introscope/install/database-scripts/dbupdate-sequences-postgres-${DB_VERSION}.0.0.sql .
docker cp em:/opt/CA/Introscope/install/database-scripts/defaults-postgres-${DB_VERSION}.0.0.sql .
docker cp em:/opt/CA/Introscope/install/database-scripts/drop-apm-tables-postgres-${DB_VERSION}.0.0.sql .
docker cp em:/opt/CA/Introscope/install/database-scripts/dropconstraints-postgres-${DB_VERSION}.0.0.sql .
docker cp em:/opt/CA/Introscope/install/database-scripts/dropindexes-postgres-${DB_VERSION}.0.0.sql .
docker cp em:/opt/CA/Introscope/install/database-scripts/droptables-postgres-${DB_VERSION}.0.0.sql .
docker cp em:/opt/CA/Introscope/install/database-scripts/dropviews-postgres-${DB_VERSION}.0.0.sql .
docker cp em:/opt/CA/Introscope/install/database-scripts/initdb-postgres-${DB_VERSION}.0.0.sql .
docker cp em:/opt/CA/Introscope/install/database-scripts/procedures-postgres-${DB_VERSION}.0.0.sql .
