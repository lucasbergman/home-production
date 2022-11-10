# Home/Production

Configurations to run services at the house or hobby clusters.

## Wherein One Dares to Dream (of Something Less Shitty)

Currently, I've got a home server and one or two cloud VMs; I think I'll add
a RaspPi to that soon. Everything is Ubuntu LTS and is managed with a grab
bag of Ansible, Docker, Docker Compose, Hashicorp Consul/Vault/Nomad, and
Terraform. Overall the setup has worked for a while:

-   Ansible is what it is, a lovely bit of decoration over running commands
    over SSH on a bunch of hosts. It's the tuxedo t-shirt of SRE tools. But
    it undeniably _works_.

-   Running services under Docker is fine overall. For a handful (notably
    mail server stuff) it's some hassle, but that's inevitable. Someone who
    runs his own mail server deserves what he gets anyway. The emerging
    Docker monoculture in FOSS is annoying but understandable.

-   Terraform is standard for good reason. It does its thing as well as that
    thing can be done; anything that did the same job would be a Terraform
    cover band. They also somehow pulled off inventing a configuration
    language that I understand and that doesn't drive me crazy.

-   If you've got lots of nodes, Nomad and its associated stuff is a way to
    do the Kubernetes thing but with a system that's possible for humans to
    understand. That is very good. But adopting that stack in a secure way
    is _hard_. It's not their fault; in particular, deploying infrastructure
    for TLS is hard.

This whole setup works, but there are some pain points:

-   There's no good sense to any of this. The server nodes are all unique,
    so there is no escaping laying out files and directories everywhere with
    Ansible. Nomad schedules Docker containers on the home server, but I use
    Docker Compose on the rest because I don't trust myself to set up the
    Hashistack securely for remote use.

-   Things get in a bad state occasionally. With Ansible you often have to
    declare commands, not the end state of the system. That's native to
    Ansible's design and the source of its flexibility, but some bugs happen
    that way. I've never gotten to the point where I can run the Ansible
    playbooks and just have everything get reliably restarted or reloaded as
    needed from any starting state. That is mostly my fault. Nomad is on a
    Raft cluster of size one, so it has lost its mind once or twice; recovery
    wasn't bad in practice but was deeply scary.

-   Because all the nodes are unique, I don't gain much from Nomad. The
    Docker abstractions like networks, volumes, and log drivers aren't
    really helping either for the same reason.

-   Because the setup across hosts isn't uniform, I'm not confident about
    backups and recovery; it's all necessarily bespoke. In general, I'm not
    sure I could recover everything if a host (or all the hosts) died. The
    tools aren't at fault for this, but bootstrapping new hosts is more manual
    than I would like; more uniformity would make consistent backups across
    everything easier to execute.

-   While we're at it, even day-to-day tinkering requires way too much insider
    knowledge. You have to know to run this Terraform stuff to mess with DNS,
    and this Ansible stuff to upgrade packages, except when it's the other
    Terraform stuff that talks to Nomad to upgrade packages. In a good system,
    each attribute of the system would appear in one file, and you push a
    button to get all the hosts into the new state.

To sort all this out, I'd like to step back and take a fresh look at the
system: the way I use Ansible is too _little_ SRE mumbo-jumbo, and Nomad is
definitely too _much_.

For a few days I tried leaning into Nix, both the package manager and NixOS.
It's all about declarative-ness and reproducible-ness, which is good for
making system configs that hold up for a long time. But I kept running over
under-documented complexity and ultimately gave up. I think it's a wonderful
idea, but Nix seems like it'll be out over its skis for a while longer.

Instead, I'm just going to try and do a better job with Terraform and Ansible,
with custom tools and containers built reliably with Bazel. I expect things
will end up having complex dependencies among the pieces, so there'll be extra
credit available for getting it _all_ to hang together with Bazel later.

Anyway, here's a vague pre-flight checklist of things that I know need to get
ported over to the new setup. I'm sure I'll think of more.

-   ☐ bootstrapping cloud assets
    -   ☐ DNS records
    -   ☐ Cloud VMs
    -   ☐ Service accounts and permissions
-   ☐ Install on main cloud VMs
    -   ☐ Secrets for cloud VMs
    -   ☐ LetsEncrypt certificates with renewal
    -   ☐ Mumble server install
    -   ☐ mail server install
    -   ☐ move Synapse/Matrix install from home
-   ☐ Install on home server
    -   ☐ Secrets for home server
    -   ☐ LetsEncrypt certificates with renewal
    -   ☐ nginx install
    -   ☐ Prometheus install
    -   ☐ Alert Manager install
    -   ☐ Prometheus Node Exporter install
    -   ☐ Prometheus prober install
    -   ☐ Grafana install
    -   ☐ Home Assistant install
    -   ☐ APC UPSD Exporter install
    -   ☐ Plex server install
    -   ☐ Unifi controller install
    -   ☐ Crappy content management cron job install
