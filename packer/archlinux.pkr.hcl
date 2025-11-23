##################################################################################
# SOURCES
##################################################################################

source "docker" "archlinux" {
  image  = "archlinux:latest"
  commit = true
  changes = [
    "LABEL maintainer=\"${var.maintainer}\"",
    "VOLUME [\"/sys/fs/cgroup\", \"/tmp\", \"/run\"]",
    "CMD [\"/usr/lib/systemd/systemd\"]"
  ]
}

##################################################################################
# BUILD
##################################################################################

build {
  sources = ["source.docker.archlinux"]

  provisioner "shell" {
    script = "${path.root}/scripts/bootstrap.sh"
  }

  provisioner "ansible" {
    galaxy_file          = "${path.root}/../ansible/requirements.yml"
    galaxy_force_install = true
    roles_path           = "${path.root}/../ansible/roles"
    playbook_file        = "${path.root}/../ansible/playbooks/main.yml"
    ansible_env_vars = [ 
      # To enable piplining, you have to edit sudoers file
      # See:https://docs.ansible.com/ansible/latest/reference_appendices/config.html#ansible-pipelining
      # "ANSIBLE_PIPELINING=true",
      "ANSIBLE_ROLES_PATH=${path.root}/../ansible/roles",
      "ANSIBLE_FORCE_COLOR=true",
      "ANSIBLE_HOST_KEY_CHECKING=false",
    ]
  }

  post-processors {
    post-processor "docker-tag" {
      repository = "${var.docker_registry}/${var.image_name}"
      tags       = [local.image_tag]
    }

    post-processor "docker-save" {
      path = "${path.root}/outputs/archlinux-ansible.tar"
    }
  }
}
