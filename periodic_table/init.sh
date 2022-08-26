#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

echo $($PSQL "")

echo $($PSQL "ALTER TABLE properties RENAME COLUMN weight TO atomic_mass")

echo $($PSQL "ALTER TABLE properties RENAME COLUMN melting_point TO melting_point_celsius")

echo $($PSQL "ALTER TABLE properties RENAME COLUMN boiling_point TO boiling_point_celsius")

echo $($PSQL "ALTER TABLE properties ALTER COLUMN melting_point_celsius SET NOT NULL")

echo $($PSQL "ALTER TABLE properties ALTER COLUMN boiling_point_celsius SET NOT NULL")

echo $($PSQL "ALTER TABLE elements ADD CONSTRAINT name_unique UNIQUE(name)")

echo $($PSQL "ALTER TABLE elements ADD CONSTRAINT symbol_unique UNIQUE(symbol)")

echo $($PSQL "ALTER TABLE elements ALTER COLUMN name SET NOT NULL")

echo $($PSQL "ALTER TABLE elements ALTER COLUMN symbol SET NOT NULL")

echo $($PSQL "ALTER TABLE properties ADD FOREIGN KEY(atomic_number) REFERENCES elements(atomic_number)")

echo $($PSQL "CREATE TABLE types()")

echo $($PSQL "ALTER TABLE types ADD COLUMN type_id INT PRIMARY KEY")

echo $($PSQL "ALTER TABLE types ADD COLUMN type VARCHAR(50) NOT NULL")

echo $($PSQL "INSERT INTO types(type_id,type) VALUES(1,'metal'), (2,'metalloid'), (3,'nonmetal')")

echo $($PSQL "alter TABLE properties ADD COLUMN type_id INT")

echo $($PSQL "UPDATE properties SET type_id=1 WHERE type='metal'")
echo $($PSQL "UPDATE properties SET type_id=2 WHERE type='metalloid'")
echo $($PSQL "UPDATE properties SET type_id=3 WHERE type='nonmetal'")

echo $($PSQL "ALTER TABLE properties ALTER COLUMN type_id SET NOT NULL")

echo $($PSQL "UPDATE elements SET symbol=INITCAP(symbol)")

echo $($PSQL "ALTER TABLE properties ALTER COLUMN atomic_mass SET DATA TYPE DECIMAL")

echo $($PSQL "UPDATE properties SET atomic_mass=trim(trailing '0' from atomic_mass::text)::numeric")

echo $($PSQL "ALTER TABLE properties DROP COLUMN type")

echo $($PSQL "ALTER TABLE properties ADD FOREIGN KEY(type_id) REFERENCES types(type_id)")

echo $($PSQL "INSERT INTO elements(atomic_number,symbol,name) VALUES(9,'F','Fluorine')")

echo $($PSQL "INSERT INTO elements(atomic_number,symbol,name) VALUES(10,'Ne','Neon')")

echo $($PSQL "INSERT INTO properties(atomic_number, atomic_mass, melting_point_celsius,boiling_point_celsius,type_id) vALUES(9,18.998,-220,-188.1,3)")
echo $($PSQL "INSERT INTO properties(atomic_number, atomic_mass, melting_point_celsius,boiling_point_celsius,type_id) vALUES(10,20.18,-248.6,-246.1,3)")

echo $($PSQL "DELETE FROM properties WHERE atomic_number=1000")
echo $($PSQL "DELETE FROM elements WHERE atomic_number=1000")