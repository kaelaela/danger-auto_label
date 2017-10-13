### auto_label

No more set label to pull request manually.
Example, you can set labels simply by changing the PR title.

if github.pr_title.include? "[WIP]"
  auto_label.set_wip(github.pr_json["number"])
end

<blockquote>Very simple usage. Set wip label automatically when the PR title contains '[WIP]'.
  <pre></pre>
</blockquote>

#### Methods

`set_wip` - Set WIP label to PR.

`set` - Set any labels to PR by this.
