### auto_label

No more set label to issue or pull request manually.  
Example, you can set labels simply by changing the PR title.

![sample](gif/sample.gif)

### Usage

Very simple usage.  

First, install gem.

```
$ gem install danger-auto_label
```

Set wip label automatically when the PR title contains '[WIP]'.

```sample.rb
  if github.pr_title.include? "[WIP]"
    auto_label.wip=(github.pr_json["number"])
  end
```

#### Methods

`wip=` - Set WIP label to PR.

`set` - Set any labels to PR by this.
