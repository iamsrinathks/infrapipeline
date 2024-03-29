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


firewall_rules = [
  for rule in local.concat_firewall_rules :
  tomap({
    for k, v in rule : substr(lower("${can(v.deny) ? "deny" : can(v.allow) ? "allow" : ""}-${local.workspace}-${local.environment_short_code}-${k}"), 0, 63) => {
      allow = can(v.allow) ? v.allow : [],
      deny  = can(v.deny) ? v.deny : []
    }
    if can(v.deny) || can(v.allow) : "skip" => {}
  }) 
  if length(rule) > 0
]


    
    
gcloud container clusters describe CLUSTER_NAME --zone ZONE --project PROJECT_ID --format='value(networkConfig.networkPlugin)'

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
      
locals {
  modified_firewall_rules = {
    for k, v in var.firewall_rules :
      "${can(v.deny) ? "deny" : can(v.allow) ? "allow" : ""}-${local.workspace}-${local.environment}-${substr(k, 0, 63 - length("${can(v.deny) ? "deny" : can(v.allow) ? "allow" : ""}-${local.workspace}-${local.environment}-"))}" => v
  }
}
  
  
  variable "ports" {
  type    = list(string)
  default = ["0-65535"]
}

locals {
  port_list = flatten([
    for port in var.ports : [
      for p in split("-", port) : range(tonumber(p), tonumber(p) + 1)
    ]
  ])
}

output "port_list" {
  value = local.port_list
}

apiVersion: v1
kind: ConfigMap
metadata:
  name: ip-masq-agent-config
  namespace: kube-system
data:
  config: |
    nonMasqueradeCIDRs:
    - <POD_CIDR>


