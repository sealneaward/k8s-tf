resource "kubernetes_service" "hello_python_service" {
  metadata {
    name = "hello-python"
  }

  spec {
    port {
      protocol    = "TCP"
      port        = 6000
      target_port = "5000"
    }

    selector = {
      app = "hello-python"
    }

    type = "LoadBalancer"
  }
}

resource "kubernetes_deployment" "hello_python" {
  metadata {
    name = "hello-python"
  }

  spec {
    replicas = 4

    selector {
      match_labels = {
        app = "hello-python"
      }
    }

    template {
      metadata {
        labels = {
          app = "hello-python"
        }
      }

      spec {
        container {
          name  = "hello-python"
          image = "hello-python:latest"

          port {
            container_port = 5000
          }

          image_pull_policy = "Never"
        }
      }
    }
  }
}
