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
    TOMCAT_BASE_IMAGE = "ideascale/jre-11:0.0.0-local"
    USER                = "ideascale"
    GROUP               = "ideascale"
    UID                 = "1000"
    GID                 = "1000"
  }
  dockerfile = "Dockerfile"
  tags = ["docker.io/ideascale/tomcat:${TAG}"]
}