#! /usr/bin/env sh
if [[ ${DEBUGPY} == 'TRUE' ]] || [[ ${DEBUGPY} == 'True' ]] || [[ ${DEBUGPY} == '1' ]]; then
    echo >&2 "Starting dedug..."
    exec python -m debugpy --listen 0.0.0.0:5678 --wait-for-client main.py
elif [[ ${DEBUG} == 'TRUE' ]] || [[ ${DEBUG} == 'True' ]] || [[ ${DEBUG} == '1' ]]; then
    echo >&2 "Starting dev..."
    exec python main.py
else
    echo >&2 "Starting prod..."
    exec python ./main.py
fi
