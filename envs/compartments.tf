/************************************************************
Compartment - workload
************************************************************/
resource "oci_identity_compartment" "workload" {
  compartment_id = var.tenancy_ocid
  name           = "oci-cloud-guard-instance-security-organize"
  description    = "For OCI Cloud Guard Instance Security Organize"
  enable_delete  = true
}