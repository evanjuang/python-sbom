#!/bin/bash

cd /src || return

if [ -f 'setup.py' ]; then
    project_config='setup.py'
elif [ -f 'pyproject.toml' ]; then
    project_config='pyproject.toml'
else
    echo "project configure file not found"
    exit 1
fi


py_venv=/venv/sbom/bin
outdir=sbom

mkdir "$outdir"
. $py_venv/activate

mv requirements.txt requirements.txt.pre

if [[ ${SKIP_UPDATE} == 1 ]];then
    echo "skip update..."
    cp requirements.txt.pre "$outdir"/requirements.txt
    python -m pip install -r "$outdir"/requirements.txt
else
    pip-compile -o "$outdir"/requirements.txt "$project_config"
    pip-sync --python-executable $py_venv/python "$outdir"/requirements.txt
fi

pip-licenses --python $py_venv/python -aud --order=name -f json --output-file "$outdir"/licenses.json
pip-audit -r "$outdir"/requirements.txt -l -f json | python -m json.tool >  "$outdir"/sbom.json
cp "$outdir"/requirements.txt .
