datacenter           = "dc1"
bind_addr            = "{{ GetInterfaceIP \"<network-interface-name>\" }}"
data_dir             = "/opt/consul"
enable_script_checks = true
leave_on_terminate   = true
log_level            = "INFO"
node_name            = "consul-server-client"

bootstrap_expect    = 1
client_addr         = "0.0.0.0"
server              = true
ui                  = true
