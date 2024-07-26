variable "HOME" {
  default = "$HOME"
}

variable "TAG" {
  default = "0.0.0-local"
}

group "default" {
  targets = ["jre17", "jre21"]
}

target "_common" {
  dockerfile = "Dockerfile"
  tags       = ["docker.io/ideascale/jre:${TAG}"]
  secret     = ["type=file,id=pro-attach-config,src=${HOME}/.local/pro-attach-config.yaml"]
}

target "jre17" {
  args = {
    JAVA_VERSION = "17"
  }
  inherits = ["_common"]
}

target "jre21" {
  args = {
    JAVA_VERSION = "21"
  }
  inherits = ["_common"]
}