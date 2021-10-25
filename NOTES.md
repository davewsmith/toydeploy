## To Do

 * Refactor main.yml into Roles, and/or divide it into provision.yml and deploy.yml
 * Add a cron job to inject toy data.
 * Add background tasks (Rq?)
 * Sort out how to go into "maintenance" mode while migrations are running
 * Figure out how to introduce styling without muddying things up too badly
   (an app issue, not a provisioning issue)
 * Make logging consistent (an app issue)
 * Set up HTTPS for the Pi (https://tailscale.com/kb/1153/enabling-https/)
    - Get letsencrypt into the provisioning
 * Provision an EC2 instance, get a domain name, set up DNS

## Day 1

Installed Ansible into a Python3 virtual environment.

Decided which Pi to play with, then created `inventory` as

    [pi]
    pi3 ansible_user=pi

Had to install `sshpass` locally, for reasons I need to review.

    $ ssh-copy-id pi@pi3

prompted for a password, then copied my public key.

Now I can talk to the Pi.

    $ ansible -i inventory -m shell -a "df -h" pi3
    [DEPRECATION WARNING]: Ansible will require Python 3.8 or newer on the controller starting with Ansible 2.12. Current version: 3.6.9 (default, 
    Jan 26 2021, 15:33:00) [GCC 8.4.0]. This feature will be removed from ansible-core in version 2.12. Deprecation warnings can be disabled by 
    setting deprecation_warnings=False in ansible.cfg.
    pi3 | CHANGED | rc=0 >>
    Filesystem      Size  Used Avail Use% Mounted on
    /dev/root        15G  4.4G  9.5G  32% /
    devtmpfs        458M     0  458M   0% /dev
    tmpfs           462M     0  462M   0% /dev/shm
    tmpfs           462M   36M  427M   8% /run
    tmpfs           5.0M  4.0K  5.0M   1% /run/lock
    tmpfs           462M     0  462M   0% /sys/fs/cgroup
    /dev/sda1        15G  963M   14G   7% /mnt/data
    /dev/mmcblk0p1   63M   22M   42M  35% /boot
    tmpfs            93M     0   93M   0% /run/user/1000

Pesky deprecation warning. Shut it off by creating `ansible.cfg` with

    [defaults]
    deprecation_warnings=False

Now

    $ ansible -i inventory -m debug -a "var=ansible_user" pi3
    pi3 | SUCCESS => {
        "ansible_user": "pi"
    }

This might provide one way of distinguishing between being on a Pi or in a VM.
(There's probably a best practice here.)


## Day 2

Added a Vagrantfile with an Ansible provisioner.

    $ vagrant up

builds a 1Gb Ubuntu 18.08 VM and runs a skeletal playbook.

    ok: [default] => {
        "ansible_user": "vagrant"
    }

Nice: One of several ways to adapt to the environment.

To keep things decluttered, playbook and associated stuff will go
in `provision/`

In anticipation of AWS, and wanting to avoid `all` meaning both Pis and
EC2 instances, inventories are now `inventory_pi` and `inventory_ec2`

    $ ansible -i inventory_pi -m debug -a "var=ansible_user" all

works.

    $ ansible-playbook -i inventory_pi provision/main.yml

sort of worked. Oddly, that didn't show `df -h` results. But

    $ ansible -i inventory_pi -m shell -a "df -h" pi3

does. Huh?

Wrote the question up and posted to serverfault.com

And... got an answer fairly quickly. I needed to store the result in a var,
then using `debug:` to display it.  Odd that the Ansible provisioner in
Vagrant behaves differently, but whatever.

Next up, launch a micro instance on EC2.

## Day 3

Yesterday's mystery explained by the `ansible.verbose = 'v'` in Vagrantfile,
which caused extra output.

Developing in a VM is convenient. A common thing to do is let Vagrant mount
the current directory as '/vagrant', but that's not in the spirit of a deploy
(it's more like using a VM to contain damage). So, a decision: pull source
from github when provisioning, or mount it? I think I'll come down on the
side of using the VM as a development aide, and provision everything except
source.

Side trip into ensuring nginx is installed, and putting test.html in place
via `template:`.

Pi3 isn't able to complete an `apt-get update`, possibly because it needs
an O/S update, so switching to Pi4.  Fortunately, nginx puts things in the
same places on both Ubuntu and Raspberry Pi OS, so this part was easy.

Note to self: When before updating Pi3, consult `install.log`
and preserve `wxbug`.

Wired things up such that in a VM,
the directory that holds the repo is mounted as `/home/vagrant/toydeploy`

On a Pi, the repo gets cloned to `/home/pi/toydeploy`.  The

    when: ansible_user != 'vagrant'

that helps that work gives me a slight itch.
On the lookout for a cleaner way.

Selective use of `when_changed: false` to avoid false changes
(e.g., `df -h` doesn't have a side-effect).
Also added `cache_valid_time: 3600` to speed things along.

## Day 4

Re-thinking the VM.
Aside from isolating changes from the host (my laptop),
the VM serves two purposes:

1. an environment for quickly developing Ansible scripts, and
2. a development environment for an App.

These are somewhat in conflict.
For app development, being able to edit the same files either inside the VM
or outside (thanks to synced folders) is convenient.
But that means skipping the `git clone` step in provisioning.
If, instead of syncing the current directory I were to clone what's in github,
I'd have to do app development exclusively inside the VM and set it up with
my private key to push from there.

Rustled up the parts (and the download) needed to flash the latest
Rasperry Pi OS onto the older Pi I'm using, and a scratch Pi.

Otherwise, no code today.

## Day 5

 * Updated an old Pi 2 with Raspberry Pi OS Lite and plugged it in to the
   home router
 * `ssh-copy-id` to it
 * installed and up'd `tailscale`
 * pointed `inventory_pi` at the Pi's tailscale ip
 * `$ ansible-playbook -i inventory_pi provision/main.yml`

and voilà, a minimally provisioned Pi.

## Day 5

Decided to mount `.` as `/vagrant`, and provision to `/home/vagrant/`.
Not the way I'm used to working in a VM,
but the VM practices I was introduced to may have been quirky.
This gets rid of the itch from day 3.

Got the app up and serving requests (`http://localhost:8080/` from the VM).

There are a few warts in provisioning that will get revisited when deploy
becomes re-deploy. The order of operations needs vetting.

First deploy to the Pi failed because... that's odd...  D'oh!
After getting the App working in the VM I forgot to push to github. D'oh!

Second deploy to the Pi succeed.

### Scope Creep

Because the intent is to provision a fully-featured Flask app, the door is
open to to revisiting some quirks in way I've been structuring Flask apps.  
For purposes of making the toy app reusable, I have it a skeletal `app/toy`
blueprint.  I'm _thinking_ that sticking a layout app, containing only
templates, at the front might work for isolating CSS framework dependencies,
but that may be a hallucination. CSS, beyond serving it up, would be out of
scope, except that handling it cleanly is an organizational issue I'll have
to cope with at some point.

## Day 6

First, a bit of tidying. Moved the goalposts by adding HTTPS to the To Do
list.

Added `ansible-lint` and cleaned warnings. Only had to `#noqa` one of them,
since pulling from HEAD is the point at the moment. Eventually, provisioning
will pull from a release tag. Best practice is to call the playbooks folder
`playbooks`, so adopting that.

Getting database (SQLite3) support in was a bit of a slog, but it's in and
working with migrations. There's probably some way of detecting whether a
migration actuall did anything, but I'll leave that for another day.

Next up, split up main.yml into pieces. I like the idea of separating
provision from deploy. I like the idea starting to support a separate
database server, but that may be getting too far ahead of things.
