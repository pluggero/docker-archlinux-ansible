FROM archlinux:latest
LABEL maintainer="Robin Plugge"

# Update system and install necessary packages.
RUN pacman -Syu --noconfirm \
    && pacman -S --needed --noconfirm \
       base-devel \
       python \
       python-pip \
       python-setuptools \
       python-yaml \
       openssl \
       libffi \
       systemd \
       systemd-sysvcompat \
       iproute2 \
       sudo \
       ansible \
    # Clean up pacman cache to reduce image size.
    && rm -rf /var/cache/pacman/pkg/*

# Fix potential UTF-8 errors with ansible-test.
RUN sed -i 's/#en_US.UTF-8/en_US.UTF-8/' /etc/locale.gen \
    && locale-gen \
    && echo "LANG=en_US.UTF-8" > /etc/locale.conf

# Create ansible user with home directory
RUN useradd -m -s /bin/bash ansible \
    && echo "ansible:ansible" | chpasswd

# Configure sudo access for ansible user with password requirement
RUN echo "ansible ALL=(ALL:ALL) ALL" > /etc/sudoers.d/ansible

# Create a default Ansible inventory file.
RUN mkdir -p /etc/ansible
RUN echo "[local]\nlocalhost ansible_user=ansible ansible_connection=local" > /etc/ansible/hosts

# Remove unnecessary getty and udev targets that result in high CPU usage when using
# multiple containers with Molecule (https://github.com/ansible/molecule/issues/1104)
RUN rm -f /lib/systemd/system/systemd*udev* \
  && rm -f /lib/systemd/system/getty.target

# Set up volumes for systemd to run properly in Docker.
VOLUME ["/sys/fs/cgroup", "/tmp", "/run"]

# Use systemd as the container's entrypoint.
CMD ["/usr/lib/systemd/systemd"]
