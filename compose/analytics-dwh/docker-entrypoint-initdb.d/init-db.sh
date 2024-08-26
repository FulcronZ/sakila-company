#!/bin/bash
set -e

clickhouse client -n <<-EOSQL
    CREATE DATABASE raw_pagila;
    CREATE DATABASE staging;
    CREATE DATABASE warehouse;
EOSQL
