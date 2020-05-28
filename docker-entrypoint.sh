#! /usr/bin/env sh

if [[ ${DEBUG} == 'TRUE' ]] || [[ ${DEBUG} == 'True' ]] || [[ ${DEBUG} == '1' ]]; then
    echo >&2 "Starting dev..."
    exec python3 -m debugpy --listen 0.0.0.0:5678 --wait-for-client main.py
else
    echo >&2 "Starting prod..."
    exec python3 ./main.py
fi
