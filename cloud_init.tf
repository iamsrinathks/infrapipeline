data "cloudinit_config" "config" {
  gzip          = false
  base64_encode = false

  part {
    content_type = "text/x-shellscript"
    content      = data.template_file.script.rendered
  }
}

data "template_file" "script" {
  template = file("scripts/nginx.sh")
}
