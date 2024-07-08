# UPSERT
MERGE `sentinelone-428814.sentinelone.sentinelone_issues` T
USING (
  SELECT
    PARSE_DATE('%Y-%m-%d', JSON_VALUE(fields, '$.dt')) AS date,
    expand,
    id,
    key,
    self,
    SPLIT(key, '-')[SAFE_OFFSET(0)] AS project,
    JSON_VALUE(fields, '$.project.name') AS project_name,
    JSON_VALUE(fields, '$.issuetype.name') AS issue_type_name,
    JSON_VALUE(fields, '$.resolution.name') AS resolution_name,
    JSON_VALUE(fields, '$.created') AS created_date,
    JSON_VALUE(fields, '$.resolutiondate') AS resolved_date,
    JSON_VALUE(fields, '$.customfield_11169.value') AS severity,
    JSON_VALUE(fields, '$.customfield_11067.value') AS team,
    JSON_VALUE(fields, '$.customfield_11089.value') AS global_release,
    JSON_VALUE(fields, '$.customfield_10026') AS story_points,
    JSON_VALUE(fields, '$.priority') AS priority,
    JSON_VALUE(fields, '$.customfield_11191.value') AS bug_type,
    JSON_VALUE(fields, '$.summary') AS summary,
    JSON_VALUE(fields, '$.customfield_11137') AS testing_scope,
    JSON_VALUE(fields, '$.customfield_11130.value') AS engineering_area,
    JSON_VALUE(fields, '$.customfield_11132') AS automation_test_name,
    JSON_VALUE(fields, '$.status.name') AS status,
    JSON_VALUE(fields, '$.reporter.displayName') AS reporter,
    JSON_VALUE(fields, '$.assignee.displayName') AS assignee_name,
    JSON_VALUE(fields, '$.customfield_10948') AS total_acv,
    JSON_VALUE(fields, '$.customfield_11087.value') AS program,
    JSON_VALUE(fields, '$.customfield_11104') AS execution_comments,
    JSON_VALUE(fields, '$.customfield_11079.value') AS display_in_big_picture,
    JSON_VALUE(fields, '$.updated') AS updated,
    JSON_VALUE(fields, '$.customfield_11099.value') AS engineering_feedback,
    JSON_VALUE(fields, '$.customfield_11118') AS proposed_text_for_limitation_or_resolved_issue,
    JSON_VALUE(fields, '$.customfield_10002.requestType.name') AS customer_request_type,
    JSON_VALUE(fields, '$.project.projectTypeKey') AS project_type,
    JSON_VALUE(fields, '$.creator.displayName') AS channel
  FROM
    `sentinelone-428814.sentinelone.tmp_sentinelone_issues`
) S
ON T.id = S.id
WHEN MATCHED AND (
    T.date != S.date OR
    T.expand != S.expand OR
    T.key != S.key OR
    T.self != S.self OR
    T.project != S.project OR
    T.project_name != S.project_name OR
    T.issue_type_name != S.issue_type_name OR
    T.resolution_name != S.resolution_name OR
    T.created_date != S.created_date OR
    T.resolved_date != S.resolved_date OR
    T.severity != S.severity OR
    T.team != S.team OR
    T.global_release != S.global_release OR
    T.story_points != S.story_points OR
    T.priority != S.priority OR
    T.bug_type != S.bug_type OR
    T.summary != S.summary OR
    T.testing_scope != S.testing_scope OR
    T.engineering_area != S.engineering_area OR
    T.automation_test_name != S.automation_test_name OR
    T.status != S.status OR
    T.reporter != S.reporter OR
    T.assignee_name != S.assignee_name OR
    T.total_acv != S.total_acv OR
    T.program != S.program OR
    T.execution_comments != S.execution_comments OR
    T.display_in_big_picture != S.display_in_big_picture OR
    T.updated != S.updated OR
    T.engineering_feedback != S.engineering_feedback OR
    T.proposed_text_for_limitation_or_resolved_issue != S.proposed_text_for_limitation_or_resolved_issue OR
    T.customer_request_type != S.customer_request_type OR
    T.project_type != S.project_type OR
    T.channel != S.channel
) THEN
  UPDATE SET
    T.date = S.date,
    T.expand = S.expand,
    T.key = S.key,
    T.self = S.self,
    T.project = S.project,
    T.project_name = S.project_name,
    T.issue_type_name = S.issue_type_name,
    T.resolution_name = S.resolution_name,
    T.created_date = S.created_date,
    T.resolved_date = S.resolved_date,
    T.severity = S.severity,
    T.team = S.team,
    T.global_release = S.global_release,
    T.story_points = S.story_points,
    T.priority = S.priority,
    T.bug_type = S.bug_type,
    T.summary = S.summary,
    T.testing_scope = S.testing_scope,
    T.engineering_area = S.engineering_area,
    T.automation_test_name = S.automation_test_name,
    T.status = S.status,
    T.reporter = S.reporter,
    T.assignee_name = S.assignee_name,
    T.total_acv = S.total_acv,
    T.program = S.program,
    T.execution_comments = S.execution_comments,
    T.display_in_big_picture = S.display_in_big_picture,
    T.updated = S.updated,
    T.engineering_feedback = S.engineering_feedback,
    T.proposed_text_for_limitation_or_resolved_issue = S.proposed_text_for_limitation_or_resolved_issue,
    T.customer_request_type = S.customer_request_type,
    T.project_type = S.project_type,
    T.channel = S.channel
WHEN NOT MATCHED THEN
  INSERT (
    date, expand, id, key, self, project, project_name, issue_type_name, resolution_name,
    created_date, resolved_date, severity, team, global_release, story_points, priority, bug_type,
    summary, testing_scope, engineering_area, automation_test_name, status, reporter, assignee_name,
    total_acv, program, execution_comments, display_in_big_picture, updated, engineering_feedback,
    proposed_text_for_limitation_or_resolved_issue, customer_request_type, project_type, channel
  ) VALUES (
    S.date, S.expand, S.id, S.key, S.self, S.project, S.project_name, S.issue_type_name, S.resolution_name,
    S.created_date, S.resolved_date, S.severity, S.team, S.global_release, S.story_points, S.priority, S.bug_type,
    S.summary, S.testing_scope, S.engineering_area, S.automation_test_name, S.status, S.reporter, S.assignee_name,
    S.total_acv, S.program, S.execution_comments, S.display_in_big_picture, S.updated, S.engineering_feedback,
    S.proposed_text_for_limitation_or_resolved_issue, S.customer_request_type, S.project_type, S.channel
  );
