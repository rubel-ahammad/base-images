variable "HOME" {
  default = "$HOME"
}

variable "TAG" {
  default = "0.0.0-local"
}

target "jre" {
  name = "jre-${java_version}"
  matrix = {
    java_version = ["17", "21"]
  }
  args = {
    UBUNTU_VERSION = "22.04"
  }
  dockerfile = "Dockerfile"
  tags = ["docker.io/ideascale/jre-${java_version}:${TAG}"]
  secret = ["type=file,id=pro-attach-config,src=${HOME}/.local/pro-attach-config.yaml"]
}