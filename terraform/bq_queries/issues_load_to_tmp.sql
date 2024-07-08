-- Example SQL to load data from Cloud Storage to a temporary table
-- CREATE OR REPLACE TABLE sentinelone.tmp_issues AS
-- SELECT *
-- FROM
--   EXTERNAL_QUERY(
--     'sentinelone.tmp_issues',
--     '''
--     SELECT * FROM `my-bucket/path/to/issues_input.json`
--     '''
--   )

LOAD DATA OVERWRITE `sentinelone-428814.sentinelone.tmp_sentinelone_issues`
(fields STRING)
FROM FILES (
  format = 'JSON',
  uris = ['gs://sentinelone_issues/issues.json']);
