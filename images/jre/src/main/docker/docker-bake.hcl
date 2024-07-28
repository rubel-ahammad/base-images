variable "HOME" {
  default = "$HOME"
}

variable "TAG" {
  default = "0.0.0-local"
}

target "jre" {
  name = "jre-${version}"
  matrix = {
    version = ["17", "21"]
  }
  args = {
    UBUNTU_VERSION = "22.04"
  }
  dockerfile = "Dockerfile"
  tags = ["docker.io/ideascale/jre:${TAG}"]
  secret = ["type=file,id=pro-attach-config,src=${HOME}/.local/pro-attach-config.yaml"]
}