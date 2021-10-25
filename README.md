# Toy Deploy

Working through what it takes to use Ansible to deploy a Flask app to a VM, to a Pi, and to an EC2 instance.

Why? Because scripting installs with bash scripts is tedious, and I want to get some more experience with Ansible.

Follow the fun in [NOTES](NOTES.md).

## Preliminaries

I'm doing this on Ubuntu 18.04. Besides some basics (e.g., `git`), this needs

 * Vagrant (from https://vagrantup.com/)
 * Virtualbox (`sudo apt-get install virtualbox`)
 * virtualenv (`sudo apt-get install virtualenv`)

Install Ansible into a Python3 virtual environment.

    $ virtualenv venv --python=python3
    $ venv/bin/pip install ansible

Thereafter activate that environment.

    $ . venv/bin/activate

## Local development

With the virtualenv activated, install requirements.

    $ pip install -r requirements.txt -r requirements_dev.txt

To run the dev server:

    $ FLASK_APP=wsgi flask run

To run tests:

    $ pytest

When adding/changing models, get a test running first, since that uses
an in-memory SQLite3 database. Then

    $ FLASK_APP=wsgi flask db migrate -m 'what changed'

The corresponding `flask db upgrade` is doing by provisioning.

If it's ever necessary to blow away migrations and start over, (say, when
it's time to remove the toy models),

    $ FLASK_APP=wsgi flask db init

resets the world.

Keep the code clean. Before commit

    $ flake8

can help avoid embarrasing mistakes, as can

    $ ansible-lint playbooks

## Building a VM

With the virtual environment activated,

    $ vagrant up

To reprovision a VM

    $ vagrant provision

## Deploying onto a Pi on the home network

I'm using existing Pis that already have my public key installed. Otherwise, `ssh-copy-id` would do that.

With the virtual environment activated,

    $ ansible -i inventory_pi -m shell -a "df -h" all
    $ ansible-playbook -i inventory_pi playbooks/main.yml

## TODO: Deploy onto an EC2 instance

Which I'll need to provision by hand (Terraform being out of scope at the moment),
and then `ssh-copy-id` my public key onto the instance.

    $ ansible-playbook -i inventory_ec2 playbooks/main.yml

## Caveat Lector

This isn't necessarily fit for anyone else's use, so use at your own risk. There are better examples to crib from.
