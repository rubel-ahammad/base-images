variable "HOME" {
  default = "$HOME"
}

variable "TOMCAT_VERSION" {
}

variable "CHISEL_VERSION" {
}

target "tomcat" {
  args = {
    UBUNTU_VERSION = "20.04"
    TOMCAT_VERSION = "${TOMCAT_VERSION}"
    JAVA_VERSION   = "17"
    CHISEL_VERSION = "${CHISEL_VERSION}"
  }
  dockerfile = "Dockerfile"
  tags = ["docker.io/ideascale/tomcat:${TOMCAT_VERSION}"]
  secret = ["type=file,id=pro-attach-config,src=pro-attach-config.yaml"]
}