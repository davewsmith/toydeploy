# Toy Deploy

[![Playbooks](https://github.com/davewsmith/toydeploy/actions/workflows/lint.yml/badge.svg)](https://github.com/davewsmith/toydeploy/actions/workflows/lint.yml)
[![Tests](https://github.com/davewsmith/toydeploy/actions/workflows/test.yml/badge.svg)](https://github.com/davewsmith/toydeploy/actions/workflows/test.yml)

Working through what it takes to use Ansible to deploy a Flask app to a VM, to a Pi, and to an EC2 instance.

Why? Because scripting installs with bash was getting tedious, and I wanted to get some more experience with Ansible.

Follow the fun in [NOTES](NOTES.md).

## Preliminaries

I'm doing this on Ubuntu 18.04. Besides some basics (e.g., `git`), this needs

 * Vagrant (from https://vagrantup.com/)
 * Virtualbox (`sudo apt-get install virtualbox`)
 * virtualenv (`sudo apt-get install virtualenv`)

Install Ansible and friends into a Python3 virtual environment.

    $ virtualenv venv --python=python3
    $ venv/bin/pip install ansible boto3 botocore

Thereafter activate that environment.

    $ . venv/bin/activate

## Local development

With the virtualenv activated, install requirements.

    (venv) $ pip install -r requirements.txt -r requirements_dev.txt

To run the dev server:

    (venv) $ FLASK_APP=wsgi flask run

To run tests:

    (venv) $ pytest

When adding/changing models, get a test running first, since that uses
an in-memory SQLite3 database. Then

    (venv) $ FLASK_APP=wsgi flask db migrate -m 'what changed'

The corresponding `flask db upgrade` is doing by provisioning.

If it's ever necessary to blow away migrations and start over, (say, when
it's time to remove the toy models),

    (venv) $ FLASK_APP=wsgi flask db init

resets the world.

Keep the code clean. Before commit

    (venv) $ flake8

can help avoid embarrasing mistakes, as can

    (venv) $ ansible-lint playbooks

## Building a VM

With the virtual environment activated,

    (venv) $ vagrant up

To reprovision a VM

    (venv) $ vagrant provision

## Deploying onto a Pi on the home network

I'm using existing Pis that already have my public key installed. Otherwise, `ssh-copy-id` would do that.

With the virtual environment activated, first get to the right place

    (venv) $ cd __provision__/ansible

then

    (venv) $ ansible -i inventory_pi -m shell -a "df -h" all
    (venv) $ ansible-playbook -i inventory_pi playbooks/main.yml

The playbook is divided into a provision part and a deploy part. After the the first run,

    (venv) $ ansible-playbook -i inventory_pi playbooks/deploy.yml

is sufficient for deploying code changes.

## Deploy onto an EC2 instance

This assumes you have an AWS account set up and keys generated.

Install the AWS CLI, following https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html,
then

    (venv) $ aws configure

to get keys into a known place.

On the AWS console, navigate to EC2, then Network & Security > Key Pairs and generate one.

### Terraform

References:
  * https://registry.terraform.io/providers/hashicorp/aws/latest/docs
  * https://learn.hashicorp.com/tutorials/terraform/aws-build 

Install Terraform, following https://learn.hashicorp.com/tutorials/terraform/install-cli, then

    (venv) $ cd __provision__/terraform

Do the following once:

    (venv) $ terraform init

When making changes to terraform files,

    (venv) $ terraform fmt

will keep them formatted, and

    (venv) $ terraform validate

will keep them correct.

### Ansible

    ### (venv) $ ansible-playbook -i inventory_ec2 playbooks/main.yml


## Caveat Lector

This isn't necessarily fit for anyone else's use, so use at your own risk. There are better examples to crib from.
