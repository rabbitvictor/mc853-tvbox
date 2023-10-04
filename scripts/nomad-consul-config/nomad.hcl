datacenter = "dc1"
data_dir   = "/opt/nomad"
bind_addr  = "0.0.0.0"

client {
	enabled = true
}

server {
    enabled          = true
    bootstrap_expect = 1
}

ui {
	enabled = true
}
