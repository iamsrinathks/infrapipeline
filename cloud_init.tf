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
      rule_name = can(rule.name) ? "${local.prefix}${substr(rule.name, 0, min(length(rule.name), 63 - length(local.prefix)))}" : null
      allow         = can(rule.allow) ? [
        for allow_rule in rule.allow : {
          ports    = allow_rule.ports
          protocol = allow_rule.protocol
        }
      ] : null
      deny          = can(rule.deny) ? [
        for deny_rule in rule.deny : {
          ports    = deny_rule.ports
          protocol = deny_rule.protocol
        }
      ] : null
      direction     = rule.direction
      source_ranges = can(rule.source_ranges) ? rule.source_ranges : null
    }
  ]
}

