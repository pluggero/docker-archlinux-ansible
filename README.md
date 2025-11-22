# Archlinux Ansible Test Image

[![Build and Release](https://github.com/pluggero/docker-archlinux-ansible/actions/workflows/release.yml/badge.svg)](https://github.com/pluggero/docker-archlinux-ansible/actions/workflows/release.yml) [![Docker pulls](https://img.shields.io/docker/pulls/pluggero/docker-archlinux-ansible.svg?maxAge=2592000)](https://hub.docker.com/r/pluggero/docker-archlinux-ansible/)

Archlinux Docker container for Ansible playbook and role testing.

## ⚠️ Security Warning

**This box is intended for testing and development purposes only. DO NOT use in production environments.**

This Docker Image contains:

- Public passwords visible in the repository
- Pre-configured users with known credentials

These are intentionally included for transparent testing but make this box completely insecure for production use.

## Tags

- `latest`: Latest stable version of Ansible, with Python 3.x.

## Requirements

- [Packer](https://www.packer.io/)
- [Ansible](https://www.ansible.com/)
- [Docker](https://www.docker.com/)

## How to Build

1. Install the required tools (Packer, Ansible, Docker).
2. Clone this repository and `cd` into it.
3. Run the build script:

```bash
./scripts/archlinux_builder.sh
```

The build process:

1. Runs a bootstrap script to install Python
2. Provisions the container with Ansible
3. Commits the image with the configured tag

## How to Use

1. Pull this image from Docker Hub: `docker pull pluggero/docker-archlinux-ansible:latest`
2. Run a container from the image:

```bash
docker run --name test-container -d --privileged \
  -v /sys/fs/cgroup:/sys/fs/cgroup:rw \
  --cgroupns=host \
  pluggero/docker-archlinux-ansible:latest
```

3. Use Ansible inside the container:

```bash
docker exec --tty test-container env TERM=xterm ansible --version
docker exec --tty test-container env TERM=xterm ansible-playbook /path/to/playbook.yml --syntax-check
```

To test Ansible roles, mount your role:

```bash
docker run --name test-container -d --privileged \
  -v /sys/fs/cgroup:/sys/fs/cgroup:rw \
  --cgroupns=host \
  --volume="$(pwd):/etc/ansible/roles/role_under_test:ro" \
  pluggero/docker-archlinux-ansible:latest
```

> **Note**: Avoid mounting your workstation's cgroup volume with read-write permissions as it can break your session. Only use this inside of a virtual machine.

## Notes

I use Docker to test my Ansible roles and playbooks on multiple OSes using CI tools like Jenkins and Travis. This container allows me to test roles and playbooks using Ansible running locally inside the container.

> **Important Note**: I use this image for testing in an isolated environment—not for production—and the settings and configuration used may not be suitable for a secure and performant production environment. Use on production servers/in the wild at your own risk!
