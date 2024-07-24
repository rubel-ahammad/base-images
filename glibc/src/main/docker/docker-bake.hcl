variable "HOME" {
  default = "$HOME"
}

variable "TAG" {
  default = "0.0.0-local"
}

target "glibc" {
    dockerfile = "Dockerfile"
    tags = ["docker.io/ideascale/glibc-base:${TAG}"]
    secret = [ "type=file,id=pro-attach-config,src=${HOME}/.local/pro-attach-config.yaml" ]
}