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

With the virtualenv activated, install requirements (once).

    $ pip install -r requirements.txt

Keep the code clean.

    $ flake8

## Building a VM

With the virtual environment activated,

    $ vagrant up

To reprovision a VM

    $ vagrant provision

## Deploying onto a Pi on the home network

I'm using existing Pis that already have my public key installed. Otherwise, `ssh-copy-id` would do that.

With the virtual environment activated,

    $ ansible -i inventory_pi -m shell -a "df -h" all
    $ ansible-playbook -i inventory_pi provision/site.yml

## TODO: Deploy onto an EC2 instance

Which I'll need to provision by hand (Terraform being out of scope at the moment),
and then `ssh-copy-id` my public key onto the instance.

    $ ansible-playbook -i inventory_ec2 provision/site.yml

## Caveat Lector

This isn't necessarily fit for anyone else's use, so use at your own risk. There are better examples to crib from.
