variable "HOME" {
  default = "$HOME"
}

variable "TAG" {
  default = "0.0.0-local"
}

target "python" {
  args = {
    UBUNTU_VERSION = "22.04"
    CHISEL_VERSION = "0.10.0"
  }
  dockerfile = "Dockerfile"
  tags = ["docker.io/ideascale/python:${TAG}"]
  secret = ["type=file,id=pro-attach-config,src=${HOME}/.local/pro-attach-config.yaml"]
}