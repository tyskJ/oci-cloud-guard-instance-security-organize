/************************************************************
Oracle Services Network
************************************************************/
data "oci_core_services" "this" {}

/************************************************************
Availability Domain & Fault Domain
************************************************************/
data "oci_identity_availability_domain" "ads" {
  compartment_id = var.tenancy_ocid
  ad_number      = 1
}

data "oci_identity_fault_domains" "fds" {
  compartment_id      = var.tenancy_ocid
  availability_domain = data.oci_identity_availability_domain.ads.name
}

/************************************************************
OS Image
************************************************************/
# 商用環境では使用するイメージのOCIDはハードコードすること（時間の経過とともに変化するため）
data "oci_core_images" "oracle_supported_image" {
  compartment_id           = oci_identity_compartment.workload.id
  shape                    = "VM.Standard.E5.Flex"
  operating_system         = "Oracle Linux"
  operating_system_version = "9"
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"
  state                    = "AVAILABLE"
}

data "oci_core_images" "windows_supported_image" {
  compartment_id           = oci_identity_compartment.workload.id
  shape                    = "VM.Standard.E5.Flex"
  operating_system         = "Windows"
  operating_system_version = "Server 2025 Standard"
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"
  state                    = "AVAILABLE"
}

/************************************************************
Region
************************************************************/
data "oci_identity_regions" "regions" {
}

/************************************************************
Cloud Guard Managed Recipes
************************************************************/
data "oci_cloud_guard_detector_recipes" "managed" {
  # Oracle 管理のレシピ (Detector & Responder) は Cloud Guard が有効化されているときのみ利用可能となるため依存関係を追加
  depends_on = [
    oci_cloud_guard_cloud_guard_configuration.this
  ]
  compartment_id = var.tenancy_ocid
}

data "oci_cloud_guard_responder_recipes" "managed" {
  # Oracle 管理のレシピ (Detector & Responder) は Cloud Guard が有効化されているときのみ利用可能となるため依存関係を追加
  depends_on = [
    oci_cloud_guard_cloud_guard_configuration.this
  ]
  compartment_id = var.tenancy_ocid
}