# frozen_string_literal: true

module Danger
  # No more set label to pull request manually.
  # Example, you can set labels simply by changing the PR title.
  #
  # @example Very simple usage. Set wip label automatically when the PR title contains "[WIP]".
  # if github.pr_title.include? "[WIP]"
  #   auto_label.wip=(github.pr_json["number"])
  # end
  #
  # @see  kaelaela/danger-auto_label
  # @tags github auto-label
  #
  class DangerAutoLabel < Plugin
    # Set WIP label to PR.
    # @param   [Number] pr
    #          A number of issue or pull request for set label.
    # @return  [void]
    #
    def wip=(pr)
      label_names = []
      labels.each do |label|
        label_names << label.name
      end
      puts("exist labels:" + label_names.join(", "))
      unless wip?
        begin
          add_label("WIP")
        rescue Octokit::UnprocessableEntity => e
          puts "WIP label is already exists."
          puts e
        end
      end
      github.api.add_labels_to_an_issue(repo, pr, [wip_label])
    end

    # Set any labels to PR by this.
    # @param   [Number] pr
    #          A number of issue or pull request for set label.
    # @param   [String] name
    #          A new label name.
    # @param   [String] color
    #          A color, in hex, without the leading #. Default is "fef2c0"
    # @return  [void]
    def set(pr, name, color)
      return if already_labled?(pr, name)

      message = ""
      if label?(name)
        message = "Set #{name} label. (Color: #{color})"
      else
        message = "Add #{name} new label. (Color: #{color})"
        add_label(name, color)
      end
      github.api.add_labels_to_an_issue(repo, pr, [name])
      puts message
    end

    # Delete label from repository.
    # @param   [String] name
    #          Delete label name.
    # @return  [void]
    def delete(name)
      begin
        github.api.delete_label!(repo, name)
      rescue Octokit::Error => e
        puts "Error message: \"#{name}\" label is not existing."
        puts e
      end
    end

    # Remove label from PR.
    # @param   [String] name
    #          Remove label name.
    # @return  [void]
    def remove(name)
      begin
        github.api.remove_label(repo, number, name)
      rescue Octokit::Error => e
        puts "Error message: \"#{name}\" label is not existing."
        puts e
      end
    end

    private

    # Add new label to repo. Use octolit api.
    # http://octokit.github.io/octokit.rb/Octokit/Client/Labels.html#add_label-instance_method
    def add_label(name, color = "fef2c0")
      puts "color: #{color}"
      github.api.add_label(repo, name, color)
    end

    def label?(name)
      labels.each do |label|
        return true if label.name == name
      end
      false
    end

    def wip?
      labels.each do |label|
        return true if label.name == "WIP" || label.name == "in progress"
      end
      false
    end

    def wip_label
      wip_label = ""
      labels.each do |label|
        if label.name == "WIP" || label.name == "in progress"
          wip_label = label.name
        end
      end
      return wip_label
    end

    def already_labled?(pr, name)
      github.api.labels_for_issue(repo, pr).any? { |label| label.name == name }
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
