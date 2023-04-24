#!/bin/bash
# This script run the scripts test cases

cd /home/scripts/tests;
psql -U postgres -f test_scripts.sql;
