module Danger
  # No more set label to pull request manually.
  # Example, you can set labels simply by changing the PR title.
  #
  # @example Very simple usage. Set wip label automatically when the PR title contains '[WIP]'.
  # if github.pr_title.include? "[WIP]"
  #   auto_label.set_wip(github.pr_json["number"])
  # end
  #
  # @see  Maekawa Yuichi/danger-auto_label
  # @tags github auto-label
  #
  class DangerAutoLabel < Plugin
    # Set WIP label to PR.
    # @param   [Number] pr
    #          A number of issue or pull request for set label.
    # @return  [void]
    #
    def set_wip(pr)
      label_names = Array.new()
      labels.each do |label|
        label_names << label.name
      end
      puts('exist labels:' + label_names.join(', '))
      if !has_wip
        begin
          add_label('WIP')
        rescue Octokit::UnprocessableEntity => e
          puts 'WIP label is already exists.'
          puts e
        end
      end
      github.api.add_labels_to_an_issue(repo, pr, [get_wip_label])
    end

    # Set any labels to PR by this.
    # @param   [Number] pr
    #          A number of issue or pull request for set label.
    # @param   [String] name
    #          A new label name.
    # @param   [Number] color
    #          A color, in hex, without the leading #. Default is 'fef2c0'
    # @return  [void]
    def set(pr, name, color)
      message = ''
      has_label = has_label(name)
      if has_label
        message = "Set #{name} label. (Color: #{color})"
      else
        message = "Add #{name} new label. (Color: #{color})"
        add_label(name, color)
      end
      github.api.add_labels_to_an_issue(repo, pr, [name])
      puts message
    end

    private
    # Add new label to repo. Use octolit api.
    # @See http://octokit.github.io/octokit.rb/Octokit/Client/Labels.html#add_label-instance_method
    def add_label(name, color='fef2c0')
      puts "color: #{color}"
      github.api.add_label(repo, name, color)
    end

    def has_label(name)
      labels.each do |label|
        return true if label.name == name
      end
      false
    end

    def has_wip
      labels.each do |label|
        return true if label.name == 'WIP' || label.name == 'in progress'
      end
      false
    end

    def get_wip_label
      wip_label = ''
      labels.each do |label|
        if (label.name == 'WIP' || label.name == 'in progress')
          wip_label = label.name
        end
      end
      return wip_label
    end

    def labels
      @labels ||= github.api.labels(repo)
    end

    def repo
      @repository ||= github.pr_json[:base][:repo][:full_name]
    end

    def number
      @issue_number ||= github.pr_json[:number]
    end
  end
end
