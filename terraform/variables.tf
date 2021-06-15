# TF_VAR_pve_user="root" TF_VAR_pve_password="SInhrotel123" TF_VAR_pve_host="node3.synchrotel.ru"
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
        "K8s_master_01" = {
            "name" = "K8s-Master-01",
            "description" = "{ \"groups\": [\"opnstack\"] }",
            "target_node" = "node1",
            "ip" = "192.168.0.45",
            "netmask" = "24",
            "gw" = "192.168.0.254"
        },
        "K8s_worker_01" = {
            "name" = "K8s-Worker-01",
            "description" = "{ \"groups\": [\"opnstack\"] }",
            "target_node" = "node2",
            "ip" = "192.168.0.46",
            "netmask" = "24",
            "gw" = "192.168.0.254"
        }
            "K8s_worker_02" = {
            "name" = "K8s-Worker-02",
            "description" = "{ \"groups\": [\"opnstack\"] }",
            "target_node" = "node3",
            "ip" = "192.168.0.47",
            "netmask" = "24",
            "gw" = "192.168.0.254"

        }
    }
}
