resource "google_bigquery_dataset" "dataset" {
  dataset_id = "${var.dataset_id}"
  location   = "EU"
}

resource "google_bigquery_table" "tmp_tabletmp_sentinelone_issues" {
  dataset_id = google_bigquery_dataset.dataset.dataset_id
  table_id   = "tmp_sentinelone_issues"
  schema     = file("bq_schemas/tmp_sentinelone_issues.json")
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

resource "google_project_iam_member" "permissions" {
  role   = "roles/iam.serviceAccountShortTermTokenMinter"
  member = "serviceAccount:service-${data.google_project.project.number}@gcp-sa-bigquerydatatransfer.iam.gserviceaccount.com"
}

# --- Scheduled queries ---

resource "google_bigquery_data_transfer_config" "query_config" {
  depends_on = [google_project_iam_member.permissions, google_project_iam_member.bq-scheduled-query-sa-iam]

  display_name           = "sentinelone_issues_tmp_load"
  location               = "EU"
  service_account_name   = google_service_account.bq-scheduled-query-sa.email
  data_source_id         = "scheduled_query"
  schedule               = "${var.schedule_tmp}"
  destination_dataset_id = google_bigquery_dataset.test_dataset.dataset_id
  params = {
    destination_table_name_template = "${var.tmp_sentinelone_issues_table}"
    write_disposition               = "WRITE_TRUNCATE"
    query                           =  "${file("bq_queries/issues_load_to_tmp.sql")}"
  }
}

resource "google_bigquery_data_transfer_config" "query_config" {
  depends_on = [google_project_iam_member.permissions, google_project_iam_member.bq-scheduled-query-sa-iam]

  display_name           = "sentinelone_issues_transform_upsert"
  location               = "EU"
  service_account_name   = google_service_account.bq-scheduled-query-sa.email
  data_source_id         = "scheduled_query"
  schedule               = "${var.schedule_upsert}"
  destination_dataset_id = google_bigquery_dataset.test_dataset.dataset_id
  params = {
    destination_table_name_template = "${var.sentinelone_issues_table}"
    write_disposition               = "WRITE_APPEND"
    query                           =  "${file("bq_queries/issues_transform_upsert.sql")}"
  }
}
