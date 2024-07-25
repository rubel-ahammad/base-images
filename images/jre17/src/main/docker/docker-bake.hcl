variable "HOME" {
  default = "$HOME"
}

variable "TAG" {
  default = "0.0.0-local"
}

target "jre17" {
    dockerfile = "Dockerfile"
    tags = ["docker.io/ideascale/jre17:${TAG}"]
    secret = [ "type=file,id=pro-attach-config,src=${HOME}/.local/pro-attach-config.yaml" ]
}