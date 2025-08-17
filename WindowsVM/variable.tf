# ----- resource group create ----

variable "rgname" {
	default = "cloud-test"
}

variable "rglocation" {
	default = "west us 2"
}


# ----- vnet create ----

variable "vnet_name" {
	default = "cloud-sac-vnet"
}

variable "address_space" {
	default = ["10.1.0.0/16"]
	type = list(string)
}


# ----- sub net create ----

variable "snet_name" {
	default = "cloud-sac-subnet"
}

variable "address_prefixes_snet" {
	default = ["10.1.1.0/24"]
	type = list(string)
}


# ----- create public IP----

variable "pip_name" {
	default = "pip-cloud"
}


# ----- create nsg----

variable "nsg_name" {
	default = "nsg-cloud"
}


# ----- create nic----
variable "nic_name" {
	default = "nic-cloud"
}

variable "ipconfig_name" {
	default = "ip-name-cloud"
}

# --- Virtual Machine ------ Windows
variable "user_name" {
	default = "azureuser"
}

variable "vm_name" {
	default = "Cloud-vm"
}

variable "vm_size" {
	default = "Standard_D4s_v3"
}

variable "pass_win" {
	default = "Pass@1234567"
}
