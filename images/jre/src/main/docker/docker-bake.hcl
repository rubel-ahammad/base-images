variable "HOME" {
  default = "$HOME"
}

variable "TAG" {
  default = "0.0.0-local"
}

target "jre" {
  name = "jre-${java_version}"
  matrix = {
    java_version = ["11", "17", "21"]
  }
  args = {
    UBUNTU_VERSION      = "22.04"
    CHISEL_VERSION      = "0.10.0"
    CHISEL_EXTRA_SLICES = java_version == "11" ? "bash_bins dash_bins coreutils_bins" : ""
    JAVA_VERSION        = "${java_version}"
    JAVA_EXTRA_MODULES  = java_version == "11" ? "" : "jdk.nio.mapmode"
    USER                = "ideascale"
    GROUP               = "ideascale"
    UID                 = "1000"
    GID                 = "1000"
  }
  dockerfile = "Dockerfile"
  tags = ["docker.io/ideascale/jre-${java_version}:${TAG}"]
  secret = ["type=file,id=pro-attach-config,src=${HOME}/.local/pro-attach-config.yaml"]
}