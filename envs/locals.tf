/************************************************************
Common
************************************************************/
locals {
  common_defined_tags = {
    format("%s.%s", oci_identity_tag_namespace.common.name, oci_identity_tag_default.key_env.tag_definition_name)                = "prd"
    format("%s.%s", oci_identity_tag_namespace.common.name, oci_identity_tag_default.key_managedbyterraform.tag_definition_name) = "true"
  }
}

/************************************************************
Region List
************************************************************/
locals {
  region_map = {
    for r in data.oci_identity_regions.regions.regions :
    r.key => r.name
  }
}

/************************************************************
Cloud Guard Managed Recipes List
************************************************************/
locals {
  detector_recipes_map = {
    for r in data.oci_cloud_guard_detector_recipes.managed.detector_recipe_collection[0].items :
    r.source_detector_recipe_id => r.id
  }
  responder_recipes_map = {
    for r in data.oci_cloud_guard_responder_recipes.managed.responder_recipe_collection[0].items :
    r.source_responder_recipe_id => r.id
  }
}