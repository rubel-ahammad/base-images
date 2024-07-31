variable "HOME" {
  default = "$HOME"
}

variable "TAG" {
  default = "0.0.0-local"
}

target "tomcat" {
  args = {
    UBUNTU_VERSION = "22.04"
    TOMCAT_VERSION = "9.0.91"
    JAVA_VERSION   = "17"
    CHISEL_VERSION = "0.10.0"
    USER           = "ideascale"
    GROUP          = "ideascale"
    UID            = "1000"
    GID            = "1000"
  }
  dockerfile = "Dockerfile"
  tags = ["docker.io/ideascale/tomcat:${TAG}"]
  secret = ["type=file,id=pro-attach-config,src=pro-attach-config.yaml"]
}