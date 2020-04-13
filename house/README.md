This directory installs stuff on our house server using [Red Hat
Ansible](https://www.ansible.com/). It’s just a single server, so there
is probably some light manual terraforming needed ahead of time, like
installing Python and Ansible, but it shouldn’t be much.

Minimum survival command:

```
$ ansible-playbook -i inventory --diff --become --ask-become-pass install.yml
```
