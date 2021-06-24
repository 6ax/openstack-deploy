variable "pm_api_url" {}
variable "pm_user" {}
variable "pm_password" {}
variable "pve_user"{}
variable "pve_password"{}
variable "pve_host"{}
variable "domain_name" {}
variable "pve_ssh_private_key" {}
variable "cloud_init_ssh_public_key" {}

variable "nodes" {
    default = {
        "opnstack-01" = {
            "description" = "{ \"groups\": [\"opnstack\"] }",
            "target_node" = "node1",
            "ip0" = "192.168.0.42",
            "netmask" = "24",
            "gw" = "192.168.0.254"
        },
        "opnstack-02" = {
            "description" = "{ \"groups\": [\"opnstack\"] }",
            "target_node" = "node2",
            "ip0" = "192.168.0.43",
            "netmask" = "24",
            "gw" = "192.168.0.254"
        },
        "opnstack-03" = {
            "description" = "{ \"groups\": [\"opnstack\"] }",
            "target_node" = "node3",
            "ip0" = "192.168.0.44",
            "netmask" = "24",
            "gw" = "192.168.0.254"
        }
    }
}
