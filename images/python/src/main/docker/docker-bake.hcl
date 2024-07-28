variable "HOME" {
  default = "$HOME"
}

variable "TAG" {
  default = "0.0.0-local"
}

group "default" {
  targets = ["python"]
}

target "python" {
  args = {
    UBUNTU_VERSION = "22.04"
  }
  dockerfile = "Dockerfile"
  tags = ["docker.io/ideascale/python:${TAG}"]
  secret = ["type=file,id=pro-attach-config,src=${HOME}/.local/pro-attach-config.yaml"]
}