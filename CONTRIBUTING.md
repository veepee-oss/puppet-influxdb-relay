Contributing
------------

You are more than welcome to submit issues and merge requests to this project.

### Puppet-lint, Rubocop and Tests

Your commits must not break any tests, Puppet-lint nor rubocop.

### Commits format

Your commits must pass `git log --check` and messages should be formated
like this (based on this excellent
[post](http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html)):

```
Summarize change in 50 characters or less

Provide more detail after the first line. Leave one blank line below the
summary and wrap all lines at 72 characters or less.

If the change fixes an issue, leave another blank line after the final
paragraph and indicate which issue is fixed in the specific format
below.
```

Also do your best to factor commits appropriately, ie not too large with
unrelated things in the same commit, and not too small with the same small
change applied N times in N different commits. If there was some accidental
reformatting or whitespace changes during the course of your commits, please
rebase them away before submitting the MR.

### Files

All files must be 80 columns width formatted (actually 79), exception only
when it is really not possible.
