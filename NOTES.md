## Day 1

Installed Ansible into a Python3 virtual environment.

Decided which pi to play with, then created `inventory` as

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

This might provide one way of distinguishing between being on a Pi or in a VM. (There's probably a best practice here.)


## Day 2

Added a Vagrantfile with an Ansible provisioner.

   $ vagrant up

builds a 1Gb Ubuntu 18.08 VM and runs a skeletal playbook.

    ok: [default] => {
        "ansible_user": "vagrant"
    }

Nice: One of several ways to adapt to the environment.

To keep things decluttered, playbook and associated stuff will go in `provision/`

In anticipation of AWS, and wanting to avoid `all` meaning both Pis and EC2 instances,
inventories are now `inventory_pi` and `inventory_ec2`

    $ ansible -i inventory_pi -m debug -a "var=ansible_user" all

works.

    $ ansible-playbook -i inventory_pi provision/main.yml

sort of worked. Oddly, it didn't show `df -h` results. But

    $ ansible -i inventory_pi -m shell -a "df -h" pi3

does. Huh?

Wrote the question up and posted to serverfault.com

