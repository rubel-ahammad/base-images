variable "HOME" {
  default = "$HOME"
}

variable "TAG" {
  default = "0.0.0-local"
}

variable "CHISEL_VERSION" {
}

target "native-runtime" {
  args = {
    UBUNTU_VERSION      = "22.04"
    CHISEL_VERSION      = "${CHISEL_VERSION}"
    CHISEL_EXTRA_SLICES = TAG == "0.0.0-local" ? "bash_bins" : ""
  }
  dockerfile = "Dockerfile"
  tags = ["docker.io/ideascale/native-runtime:${TAG}"]
  secret = ["type=file,id=pro-attach-config,src=pro-attach-config.yaml"]
}