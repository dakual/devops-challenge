# creating frontend service
resource "kubernetes_deployment" "frontend" {
  metadata {
    name = "redacre-frontend"
    labels = {
      app = "redacre-frontend"
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "redacre-frontend"
      }
    }
    template {
      metadata {
        labels = {
          app = "redacre-frontend"
        }
      }
      spec {
        container {
          image = "public.ecr.aws/m2a7z1o1/frontend:latest"
          name  = "redacre-frontend"
          port {
            container_port = 80
          }
        }
      }
    }
  }
}

# creating frontend with loadbalancer service
resource "kubernetes_service" "frontend" {
  metadata {
    name = "frontend2"
  }

  spec {
    port {
      port = 80
      target_port = 80
    }
    selector = {
      app = "redacre-frontend"
    }
    type = "LoadBalancer"
  }
}

# creating backend deployment
resource "kubernetes_deployment" "backend" {
  metadata {
    name = "redacre-backend"
    labels = {
      app = "redacre-backend"
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "redacre-backend"
      }
    }
    template {
      metadata {
        labels = {
          app = "redacre-backend"
        }
      }
      spec {
        container {
          image = "public.ecr.aws/m2a7z1o1/backend:latest"
          name  = "redacre-backend"
          port {
            container_port = 5000
          }
        }
      }
    }
  }
}


# creating backend service
resource "kubernetes_service" "backend" {
  metadata {
    name = "backend"
  }

  spec {
    port {
      port = 5000
      target_port = 5000
    }
    selector = {
      app = "redacre-backend"
    }
  }
}