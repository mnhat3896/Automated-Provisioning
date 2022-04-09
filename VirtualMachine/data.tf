# Render a part using a `template_file`
data "template_file" "script" {
  template = "${file("${path.module}/scripts/init.tpl")}"

  vars = {
    # Put argument to pass to init.tpl in here
  }
}

data "template_cloudinit_config" "config" {
  gzip          = true
  base64_encode = true

  # Main cloud-config configuration file.
  part {
    filename     = "init.cfg"
    content_type = "text/cloud-config"
    content      = "${data.template_file.script.rendered}"
  }
}