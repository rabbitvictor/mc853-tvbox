job "rabbitmq" {
  datacenters = ["dc1"]
  type        = "service"

  group "rabbitmq" {
    count = 2

    network {
      mode = "host"

      port "rabbitmq" {
        to = 5672
      }

      port "rabbitmq-management" {
        to = 15672
      }
    }

    task "rabbitmq" {
      driver = "docker"

      config {
        image = "rabbitmq:3.12.6-management-alpine"
        volumes = [
          "local/enabled_plugins:/etc/rabbitmq/enabled_plugins",
          "local/rabbitmq.conf:/etc/rabbitmq/rabbitmq.conf",
        ]
      }

      resources {
        cpu    = 300
        memory = 300
      }

      template {
        data = <<EOH
[rabbitmq_management].
EOH

        destination = "local/enabled_plugins"
      }

      template {
        data        = <<EOH
EOH
        destination = "local/rabbitmq.conf"
      }
    }
  }
}
