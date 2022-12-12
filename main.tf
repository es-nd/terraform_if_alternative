locals {
  params = {
    one = {
      name         = "${var.gcp_project_id}-one"
      is_necessary = true
      labels = {
        team = "alpha"
      }
    },
    two = {
      name         = "${var.gcp_project_id}-two"
      is_necessary = true
      labels       = null
      lifecycle_rule = {
        action = {
          type          = "SetStorageClass"
          storage_class = "ARCHIVE"
        }
      }
    },
    three = {
      name = "${var.gcp_project_id}-three"
    },
  }
}

resource "google_storage_bucket" "collection" {
  for_each = { for param, attributes in local.params : param => attributes if can(attributes.is_necessary) }

  name                     = each.value.name
  location                 = "asia-northeast1"
  storage_class            = "STANDARD"
  public_access_prevention = "enforced"
  labels                   = each.value.labels

  dynamic "lifecycle_rule" {
    for_each = can(each.value.lifecycle_rule) ? [1] : []

    content {
      action {
        type          = each.value.lifecycle_rule.action.type
        storage_class = each.value.lifecycle_rule.action.storage_class
      }
      condition {}
    }
  }
}
