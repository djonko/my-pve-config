## How to fix gitea duplication key 
exemple `
2024/09/09 23:11:16 .../repo/pull_review.go:332:UpdateViewedFiles() [E] UpdateReview: pq: duplicate key value violates unique constraint "review_state_pkey"
`
```
SELECT setval('review_state_id_seq', (SELECT MAX(id) FROM review_state));
```
