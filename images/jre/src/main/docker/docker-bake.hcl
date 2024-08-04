variable "HOME" {
  default = "$HOME"
}

variable "TAG" {
  default = "0.0.0-local"
}

variable "CHISEL_VERSION" {
}

target "jre" {
  name = "jre-${java_version}"
  matrix = {
    java_version = ["11", "17", "21"]
  }
  args = {
    UBUNTU_VERSION      = "20.04"
    CHISEL_VERSION      = "${CHISEL_VERSION}"
    CHISEL_EXTRA_SLICES = TAG == "0.0.0-local" ? "bash_bins coreutils_bins" : ""
    JAVA_VERSION        = "${java_version}"
  }
  dockerfile = "Dockerfile"
  tags = ["docker.io/ideascale/jre-${java_version}:${TAG}"]
  secret = ["type=file,id=pro-attach-config,src=pro-attach-config.yaml"]
}