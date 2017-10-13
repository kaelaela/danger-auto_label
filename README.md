### auto_label

No more set label to issue or pull request manually.  
Example, you can set labels simply by changing the PR title.

> Very simple usage. Set wip label automatically when the PR title contains '[WIP]'.
  ```sample.rb
  if github.pr_title.include? "[WIP]"
    auto_label.set_wip(github.pr_json["number"])
  end
  ```

#### Methods

`set_wip` - Set WIP label to PR.

`set` - Set any labels to PR by this.
