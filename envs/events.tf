/************************************************************
Events
************************************************************/
# イベントは発生したリソースのコンパートメントにプッシュされる
# ルールは、所属するコンパートメント及びサブコンパートメントのイベントを拾えるためルートに作成
resource "oci_events_rule" "this" {
  compartment_id = var.tenancy_ocid
  display_name   = "cloud-guard-event-root"
  is_enabled     = true
  condition = jsonencode({
    eventType = [
      "com.oraclecloud.cloudguard.problemdetected"
    ]
    data = {}
  })
  actions {
    actions {
      is_enabled  = true
      action_type = "ONS"
      topic_id    = oci_ons_notification_topic.this.topic_id
    }
  }
}