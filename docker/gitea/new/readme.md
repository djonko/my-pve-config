## How to fix gitea duplication key 
exemple `
2024/09/09 23:11:16 .../repo/pull_review.go:332:UpdateViewedFiles() [E] UpdateReview: pq: duplicate key value violates unique constraint "review_state_pkey"
`
```
SELECT setval('review_state_id_seq', (SELECT MAX(id) FROM review_state));
```
all command
```sql
SELECT setval('access_id_seq', (SELECT MAX(id) FROM access));
SELECT setval('access_token_id_seq', (SELECT MAX(id) FROM access_token));
SELECT setval('action_id_seq', (SELECT MAX(id) FROM action));
SELECT setval('action_artifact_id_seq', (SELECT MAX(id) FROM action_artifact));
SELECT setval('action_run_id_seq', (SELECT MAX(id) FROM action_run));
SELECT setval('action_run_job_id_seq', (SELECT MAX(id) FROM action_run_job));
SELECT setval('action_runner_id_seq', (SELECT MAX(id) FROM action_runner));
SELECT setval('action_runner_token_id_seq', (SELECT MAX(id) FROM action_runner_token));
SELECT setval('action_schedule_id_seq', (SELECT MAX(id) FROM action_schedule));
SELECT setval('action_schedule_spec_id_seq', (SELECT MAX(id) FROM action_schedule_spec));
SELECT setval('action_task_id_seq', (SELECT MAX(id) FROM action_task));
SELECT setval('action_task_output_id_seq', (SELECT MAX(id) FROM action_task_output));
SELECT setval('action_task_step_id_seq', (SELECT MAX(id) FROM action_task_step));
SELECT setval('action_tasks_version_id_seq', (SELECT MAX(id) FROM action_tasks_version));
SELECT setval('action_variable_id_seq', (SELECT MAX(id) FROM action_variable));
SELECT setval('attachment_id_seq', (SELECT MAX(id) FROM attachment));
SELECT setval('badge_id_seq', (SELECT MAX(id) FROM badge));
SELECT setval('branch_id_seq', (SELECT MAX(id) FROM branch));
SELECT setval('collaboration_id_seq', (SELECT MAX(id) FROM collaboration));
SELECT setval('comment_id_seq', (SELECT MAX(id) FROM comment));
SELECT setval('commit_status_id_seq', (SELECT MAX(id) FROM commit_status));
SELECT setval('commit_status_index_id_seq', (SELECT MAX(id) FROM commit_status_index));
SELECT setval('commit_status_summary_id_seq', (SELECT MAX(id) FROM commit_status_summary));
SELECT setval('dbfs_data_id_seq', (SELECT MAX(id) FROM dbfs_data));
SELECT setval('dbfs_meta_id_seq', (SELECT MAX(id) FROM dbfs_meta));
SELECT setval('deploy_key_id_seq', (SELECT MAX(id) FROM deploy_key));
SELECT setval('email_address_id_seq', (SELECT MAX(id) FROM email_address));
SELECT setval('follow_id_seq', (SELECT MAX(id) FROM follow));
SELECT setval('gpg_key_id_seq', (SELECT MAX(id) FROM gpg_key));
SELECT setval('gpg_key_import_id_seq', (SELECT MAX(id) FROM gpg_key_import));
SELECT setval('hook_task_id_seq', (SELECT MAX(id) FROM hook_task));
SELECT setval('issue_id_seq', (SELECT MAX(id) FROM issue));
SELECT setval('issue_assignees_id_seq', (SELECT MAX(id) FROM issue_assignees));
SELECT setval('issue_content_history_id_seq', (SELECT MAX(id) FROM issue_content_history));
SELECT setval('issue_dependency_id_seq', (SELECT MAX(id) FROM issue_dependency));
SELECT setval('issue_label_id_seq', (SELECT MAX(id) FROM issue_label));
SELECT setval('issue_user_id_seq', (SELECT MAX(id) FROM issue_user));
SELECT setval('issue_watch_id_seq', (SELECT MAX(id) FROM issue_watch));
SELECT setval('label_id_seq', (SELECT MAX(id) FROM label));
SELECT setval('language_stat_id_seq', (SELECT MAX(id) FROM language_stat));
SELECT setval('lfs_lock_id_seq', (SELECT MAX(id) FROM lfs_lock));
SELECT setval('lfs_meta_object_id_seq', (SELECT MAX(id) FROM lfs_meta_object));
SELECT setval('login_source_id_seq', (SELECT MAX(id) FROM login_source));
SELECT setval('milestone_id_seq', (SELECT MAX(id) FROM milestone));
SELECT setval('mirror_id_seq', (SELECT MAX(id) FROM mirror));
SELECT setval('notice_id_seq', (SELECT MAX(id) FROM notice));
SELECT setval('notification_id_seq', (SELECT MAX(id) FROM notification));
SELECT setval('oauth2_application_id_seq', (SELECT MAX(id) FROM oauth2_application));
SELECT setval('oauth2_authorization_code_id_seq', (SELECT MAX(id) FROM oauth2_authorization_code));
SELECT setval('oauth2_grant_id_seq', (SELECT MAX(id) FROM oauth2_grant));
SELECT setval('org_user_id_seq', (SELECT MAX(id) FROM org_user));
SELECT setval('package_id_seq', (SELECT MAX(id) FROM package));
SELECT setval('package_blob_id_seq', (SELECT MAX(id) FROM package_blob));
SELECT setval('package_cleanup_rule_id_seq', (SELECT MAX(id) FROM package_cleanup_rule));
SELECT setval('package_file_id_seq', (SELECT MAX(id) FROM package_file));
SELECT setval('package_property_id_seq', (SELECT MAX(id) FROM package_property));
SELECT setval('package_version_id_seq', (SELECT MAX(id) FROM package_version));
SELECT setval('project_id_seq', (SELECT MAX(id) FROM project));
SELECT setval('project_board_id_seq', (SELECT MAX(id) FROM project_board));
SELECT setval('project_issue_id_seq', (SELECT MAX(id) FROM project_issue));
SELECT setval('protected_branch_id_seq', (SELECT MAX(id) FROM protected_branch));
SELECT setval('protected_tag_id_seq', (SELECT MAX(id) FROM protected_tag));
SELECT setval('public_key_id_seq', (SELECT MAX(id) FROM public_key));
SELECT setval('pull_auto_merge_id_seq', (SELECT MAX(id) FROM pull_auto_merge));
SELECT setval('pull_request_id_seq', (SELECT MAX(id) FROM pull_request));
SELECT setval('push_mirror_id_seq', (SELECT MAX(id) FROM push_mirror));
SELECT setval('reaction_id_seq', (SELECT MAX(id) FROM reaction));
SELECT setval('release_id_seq', (SELECT MAX(id) FROM release));
SELECT setval('renamed_branch_id_seq', (SELECT MAX(id) FROM renamed_branch));
SELECT setval('repo_archiver_id_seq', (SELECT MAX(id) FROM repo_archiver));
SELECT setval('repo_indexer_status_id_seq', (SELECT MAX(id) FROM repo_indexer_status));
SELECT setval('repo_redirect_id_seq', (SELECT MAX(id) FROM repo_redirect));
SELECT setval('repo_transfer_id_seq', (SELECT MAX(id) FROM repo_transfer));
SELECT setval('repo_unit_id_seq', (SELECT MAX(id) FROM repo_unit));
SELECT setval('repository_id_seq', (SELECT MAX(id) FROM repository));
SELECT setval('review_id_seq', (SELECT MAX(id) FROM review));
SELECT setval('review_state_id_seq', (SELECT MAX(id) FROM review_state));
SELECT setval('secret_id_seq', (SELECT MAX(id) FROM secret));
SELECT setval('star_id_seq', (SELECT MAX(id) FROM star));
SELECT setval('stopwatch_id_seq', (SELECT MAX(id) FROM stopwatch));
SELECT setval('system_setting_id_seq', (SELECT MAX(id) FROM system_setting));
SELECT setval('task_id_seq', (SELECT MAX(id) FROM task));
SELECT setval('team_id_seq', (SELECT MAX(id) FROM team));
SELECT setval('team_invite_id_seq', (SELECT MAX(id) FROM team_invite));
SELECT setval('team_repo_id_seq', (SELECT MAX(id) FROM team_repo));
SELECT setval('team_unit_id_seq', (SELECT MAX(id) FROM team_unit));
SELECT setval('team_user_id_seq', (SELECT MAX(id) FROM team_user));
SELECT setval('topic_id_seq', (SELECT MAX(id) FROM topic));
SELECT setval('tracked_time_id_seq', (SELECT MAX(id) FROM tracked_time));
SELECT setval('two_factor_id_seq', (SELECT MAX(id) FROM two_factor));
SELECT setval('upload_id_seq', (SELECT MAX(id) FROM upload));
SELECT setval('user_id_seq', (SELECT MAX(id) FROM "user"));
SELECT setval('user_badge_id_seq', (SELECT MAX(id) FROM user_badge));
SELECT setval('user_blocking_id_seq', (SELECT MAX(id) FROM user_blocking));
SELECT setval('user_open_id_id_seq', (SELECT MAX(id) FROM user_open_id));
SELECT setval('user_redirect_id_seq', (SELECT MAX(id) FROM user_redirect));
SELECT setval('user_setting_id_seq', (SELECT MAX(id) FROM user_setting));
SELECT setval('version_id_seq', (SELECT MAX(id) FROM version));
SELECT setval('watch_id_seq', (SELECT MAX(id) FROM watch));
SELECT setval('webauthn_credential_id_seq', (SELECT MAX(id) FROM webauthn_credential));
```
