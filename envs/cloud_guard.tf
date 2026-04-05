/************************************************************
Configuration
************************************************************/
resource "oci_cloud_guard_cloud_guard_configuration" "this" {
  depends_on = [
    oci_identity_policy.cloud_guard_policy
  ]
  compartment_id        = var.tenancy_ocid
  reporting_region      = local.region_map["NRT"]
  status                = "ENABLED" # ENABLED or DISABLED
  self_manage_resources = false
}

/************************************************************
Custom Responder Recipe
************************************************************/
resource "oci_cloud_guard_responder_recipe" "this" {
  depends_on = [
    oci_cloud_guard_cloud_guard_configuration.this
  ]
  compartment_id             = var.tenancy_ocid
  display_name               = "custom-responder-recipe"
  source_responder_recipe_id = local.responder_recipes_map["Oracle_Managed_Responder_Recipe"]
  responder_rules {
    responder_rule_id = "EVENT"
    details {
      is_enabled = true
    }
  }
  responder_rules {
    responder_rule_id = "DELETE_IAM_POLICY"
    details {
      is_enabled = false
    }
  }
  responder_rules {
    responder_rule_id = "DELETE_INTERNET_GATEWAY"
    details {
      is_enabled = false
    }
  }
  responder_rules {
    responder_rule_id = "DELETE_PUBLIC_IP"
    details {
      is_enabled = false
    }
  }
  responder_rules {
    responder_rule_id = "DISABLE_IAM_USER"
    details {
      is_enabled = false
    }
  }
  responder_rules {
    responder_rule_id = "ENABLE_DB_BACKUP"
    details {
      is_enabled = false
    }
  }
  responder_rules {
    responder_rule_id = "MAKE_BUCKET_PRIVATE"
    details {
      is_enabled = true
    }
  }
  responder_rules {
    responder_rule_id = "ROTATE_VAULT_KEY"
    details {
      is_enabled = false
    }
  }
  responder_rules {
    responder_rule_id = "STOP_INSTANCE"
    details {
      is_enabled = false
    }
  }
  responder_rules {
    responder_rule_id = "TERMINATE_INSTANCE"
    details {
      is_enabled = false
    }
  }
}

/************************************************************
Targets
************************************************************/
resource "oci_cloud_guard_target" "root" {
  depends_on = [
    oci_cloud_guard_cloud_guard_configuration.this
  ]
  compartment_id       = var.tenancy_ocid
  display_name         = "all"
  target_resource_id   = var.tenancy_ocid
  target_resource_type = "COMPARTMENT"
  target_detector_recipes {
    detector_recipe_id = local.detector_recipes_map["Oracle_Managed_Recipe_Configuration"]
  }
  target_detector_recipes {
    detector_recipe_id = local.detector_recipes_map["Oracle_Managed_Recipe_Activity"]
  }
  target_responder_recipes {
    responder_recipe_id = oci_cloud_guard_responder_recipe.this.id
  }
}