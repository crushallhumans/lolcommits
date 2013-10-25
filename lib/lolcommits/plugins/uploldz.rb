require 'rest_client'

module Lolcommits
  class Uploldz < Plugin
    attr_accessor :endpoint, :tumblr_endpoint

    def initialize(runner)
      super

      self.name     = 'uploldz'
      self.default  = true
      self.tumblr_endpoint = 'http://dev-crushing-768cb93d.ewr01.tumblr.net:9191/branchselfie/index.php'
    end

    def run
      repo = self.runner.repo.to_s
      sha = self.runner.sha.to_s
      branch = self.runner.branch.to_s
      user = self.runner.user.to_s
      if repo.empty?
        puts "Repo is empty, skipping upload"
      else
        plugdebug "Calling " + tumblr_endpoint
        plugdebug "repo = " + repo
        plugdebug "user = " + user
        plugdebug "sha = " + sha
        plugdebug "branch = " + branch
        plugdebug "action = " + 'receiver'
        RestClient.post(tumblr_endpoint, 
          :file => File.new(self.runner.main_image), 
          :repo => repo,
          :sha => sha,
          :user => user,
          :branch => branch,
          :action => 'receiver'
        )
      end
    end
    
  end
end
