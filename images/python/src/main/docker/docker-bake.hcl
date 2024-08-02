variable "HOME" {
  default = "$HOME"
}

variable "TAG" {
  default = "0.0.0-local"
}

variable "PYTHON_VERSION" {
}

variable "CHISEL_VERSION" {
}

target "python" {
  args = {
    UBUNTU_VERSION      = "22.04"
    PYTHON_VERSION      = "${PYTHON_VERSION}"
    CHISEL_VERSION      = "${CHISEL_VERSION}"
    CHISEL_EXTRA_SLICES = TAG == "0.0.0-local" ? "bash_bins" : ""
  }
  dockerfile = "Dockerfile"
  tags = ["docker.io/ideascale/python:${TAG}"]
  secret = ["type=file,id=pro-attach-config,src=pro-attach-config.yaml"]
}