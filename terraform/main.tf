resource "google_bigquery_dataset" "dataset" {
  dataset_id = "${var.dataset_id}"
  location   = "EU"
}

resource "google_bigquery_table" "sentinelone_issues" {
  dataset_id = google_bigquery_dataset.dataset.dataset_id
  table_id   = "sentinelone_issues"
  schema     = file("bq_schemas/sentinelone_issues.json")
}

# --- Service Account and permissions ---

resource "google_service_account" "bq-scheduled-query-sa" {
  account_id   = "bq-scheduled-query-sa"
  display_name = "A service account to run bq scheduled queries"
}

resource "google_project_iam_member" "bq-scheduled-query-sa-iam" {
  depends_on = [google_service_account.bq-scheduled-query-sa]
  project    = "${var.project_id}"
  role       = "roles/bigquery.admin"
  member     = "serviceAccount:${google_service_account.bq-scheduled-query-sa.email}"
}

# data source to get project details; if project_id is not provided, the provider project is used
data "google_project" "project" {
    project_id = "sentinelone-428814"
}

resource "google_storage_bucket_iam_member" "sentinelone_issues_bucket_permissions" {
  bucket     = "sentinelone_issues"
  role       = "roles/storage.objectViewer"
  member     = "serviceAccount:${google_service_account.bq-scheduled-query-sa.email}"
}

# --- Scheduled queries ---

resource "google_bigquery_data_transfer_config" "issues_tmp_load_query_config" {
  display_name           = "sentinelone_issues_tmp_load"
  location               = "EU"
  service_account_name   = google_service_account.bq-scheduled-query-sa.email
  data_source_id         = "scheduled_query"
  schedule               = "${var.schedule_tmp_load}"
  destination_dataset_id = google_bigquery_dataset.dataset.dataset_id
  params = {
    query                = "${file("bq_queries/issues_tmp_load.sql")}"
  }
}

resource "google_bigquery_data_transfer_config" "issues_transform_upsert_query_config" {
  display_name           = "sentinelone_issues_transform_upsert"
  location               = "EU"
  service_account_name   = google_service_account.bq-scheduled-query-sa.email
  data_source_id         = "scheduled_query"
  schedule               = "${var.schedule_upsert}"
  destination_dataset_id = google_bigquery_dataset.dataset.dataset_id
  params = {
    query                = "${file("bq_queries/issues_transform_upsert.sql")}"
  }
}
