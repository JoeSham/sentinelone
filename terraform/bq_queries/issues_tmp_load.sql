# LOAD
LOAD DATA OVERWRITE `sentinelone-428814.sentinelone.tmp_sentinelone_issues`
(id INTEGER, key STRING, self STRING, expand STRING, fields JSON)
FROM FILES (
  format = 'JSON',
  uris = ['gs://sentinelone_issues/issues.json']);
