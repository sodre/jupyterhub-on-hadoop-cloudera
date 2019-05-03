#!/usr/bin/env python

import json
import os
import shutil
from subprocess import check_call, check_output

import conda_pack
import ruamel_yaml as yaml
from conda.cli.python_api import Commands, run_command
from jinja2 import Environment, FileSystemLoader


def build_parcel():
    jinja_env = Environment(loader=FileSystemLoader('templates'))

    (jpy_version, parcel_version) = get_version()

    # Create the JupyterHub Environment
    render_environment_yaml(jinja_env, jpy_version=jpy_version)
    with open('environment.yml') as f:
        conda_env = yaml.load(f, Loader=yaml.Loader)
    check_call('conda env create --force -p {name}'.format(**conda_env).split(' '))

    # Get the complete list of installed packages
    components = json.loads(run_command(Commands.LIST, '--json', '-p', conda_env['name'])[0])
    jpy_version = [x['version'] for x in components if x['name'] == conda_env['name']][0]

    # Create the meta folder under the conda-environment
    meta_dir = os.path.join(conda_env['name'], 'meta')
    os.makedirs(meta_dir, exist_ok=True)

    # Create the meta/parcel.json file
    parcel_template = jinja_env.get_template('parcel.yaml')
    parcel_rendered = parcel_template.render(conda_env=conda_env,
                                             jpy_version=jpy_version,
                                             parcel_version=parcel_version,
                                             components=components)
    parcel_dict = yaml.load(parcel_rendered, Loader=yaml.Loader)

    parcel_json = os.path.join(meta_dir, 'parcel.json')
    with open(parcel_json, 'w') as f:
        json.dump(parcel_dict, f)

    print(check_output(['validator.sh', '-p', parcel_json]).decode('utf-8'))

    # Create the scripts.defines file (a.k.a. activate script)
    shutil.copy('env.sh', os.path.join(meta_dir, parcel_dict['scripts']['defines']))

    # Use conda-pack to create the .parcel file
    if os.path.exists('parcels'):
        shutil.rmtree('parcels')
    os.makedirs('parcels', exist_ok=True)
    parcel_fqn = '{name}-{version}'.format(**parcel_dict)
    parcel_file = conda_pack.pack(prefix=conda_env['name'],
                                  output='%s-distro.parcel' % parcel_fqn,
                                  arcroot=parcel_fqn,
                                  dest_prefix='/opt/cloudera/parcels/%s' % parcel_fqn,
                                  format="tar.gz",
                                  force=True)

    # Link generated file to selected distros
    distros = ['el6', 'el7']
    for distro in distros:
        dest_name = 'parcels/{}-{}.parcel'.format(parcel_fqn, distro)
        os.symlink('../%s-distro.parcel' % parcel_fqn, dest_name)
        check_call(['validator.sh', '-f', dest_name])

    # Generate the parcel manifest file
    print(check_output(['make_manifest.py', 'parcels']).decode('utf-8'))


if __name__ == '__main__':
    build_parcel()
