i_provider = {
  access_key = "AKIAWLOI4CKNKLZGBEQS",
  secret_key = "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"
}
i_vpc                  = { cidr_block = "10.0.0.0/16" }
i_security_group_my_ip = { ssh_cidr_blocks = ["49.49.250.21/32"] }
i_ec2                  = { ami = "ami-0fa377108253bf620", key_name = "kwida-key-pair" }
