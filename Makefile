.PHONEY: help
help:
	@grep -E '^[0-9a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
	sort | \
	awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONEY: update-origin-live
update-origin-live: ## update origin/live from upstream (after fetching)
	@git fetch --multiple origin upstream
	@git push origin upstream/live:live

.PHONEY: fetch-lastest-artifacts
fetch-lastest-artifacts: ## fetch the latest (separately-managed) artifacts
	@./.fetch.clj

.PHONEY: rebase
rebase: update-origin-live ## rebase current branch onto upstream/live
	@git rebase --interactive --autosquash --onto upstream/live upstream/live "$$(git branch --show-current)"
	@git symbolic-ref -q HEAD >/dev/null 2>/dev/null || echo "\n\n==> after this you may be on a detached HEAD; if so you probably want to:\n\tgit branch -f $$(git check-ref-format --branch "@{-1}" 2>/dev/null)\\n\tgit switch \$$_"
