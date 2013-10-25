module Lolcommits
  class GitInfo
    include Methadone::CLILogging
    attr_accessor :sha, :message, :repo_internal_path, :repo, :branch

    def initialize
      debug "GitInfo: attempting to read local repository"
      g    = Git.open('.')
      debug "GitInfo: reading commits logs"
      commit = g.log.first
      debug "GitInfo: most recent commit is '#{commit}'"

      self.message = commit.message.split("\n").first
      self.sha     = commit.sha[0..10]
      self.repo_internal_path = g.repo.path
      
      regex = /.*[:\/]([\w\-]*).git/
      github_https_regex = /([^\/]+)/
      github_https_match = g.remote.url.scan github_https_regex if g.remote.url
      match = g.remote.url.scan regex if g.remote.url
      if (github_https_match.nil? && (github_https_match.count > 0))
        self.repo = github_https_match[-1][0]
      elsif (match)
        self.repo = match[1]
      elsif !g.repo.path.empty?
        self.repo = g.repo.path.split(File::SEPARATOR)[-2]
      end

      branch = 'unknown'
      branches = `git branch`.split("\n")
      debug "branches " + branches.to_s
      branch_regex = /^\s*\*\s*(.*)$/
      branches.each do |i|
        match = i.scan branch_regex
        if (match.count > 0) 
          debug "branches '" + match.inspect + "'"
          branch = match[0][0]
          break
        end
      end
      self.branch = branch

      debug "GitInfo: parsed the following values from commit:"
      debug "GitInfo: \t#{self.message}"
      debug "GitInfo: \t#{self.sha}"
      debug "GitInfo: \t#{self.repo_internal_path}" 
      debug "GitInfo: \t#{self.repo}"
      debug "GitInfo: \t#{self.branch}"
    end
  end
end
