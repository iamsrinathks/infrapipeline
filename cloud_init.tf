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



locals {
  modified_firewall_rules = [
    for rule in var.firewall_rules : {
      name          = "prefix-" + (length(rule.name) > 63 ? trim(rule.name, 63) : rule.name)
      allow         = [
        for allow_rule in rule.allow : {
          ports    = allow_rule.ports
          protocol = allow_rule.protocol
        }
      ]
      deny          = [
        for deny_rule in rule.deny : {
          ports    = deny_rule.ports
          protocol = deny_rule.protocol
        }
      ]
      direction     = rule.direction
      source_ranges = rule.source_ranges
    }
  ]
}
