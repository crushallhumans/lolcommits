require 'rest_client'

module Lolcommits
  class Uploldz < Plugin
    attr_accessor :endpoint, :tumblr_endpoint

    def initialize(runner)
      super

      self.name     = 'uploldz'
      self.default  = true
      self.tumblr_endpoint = 'http://dev-crushing-768cb93d.ewr01.tumblr.net:9191/branchselfie/'
      self.options.concat(['endpoint'])
    end

    def run
      repo = self.runner.repo.to_s
      branch = self.runner.branch.to_s
      user = self.runner.user.to_s
#      if configuration['endpoint'].empty?
#        puts "Endpoint URL is empty, please run lolcommits --config to add one."
      if repo.empty?
        puts "Repo is empty, skipping upload"
      else
        plugdebug "Calling " + tumblr_endpoint
        plugdebug "repo = " + repo
        plugdebug "user = " + user
        plugdebug "branch = " + branch
        plugdebug "action = " + 'receiver'
        RestClient.post(tumblr_endpoint, 
          :file => File.new(self.runner.main_image),
          :repo => repo,
          :user => user,
          :branch => branch,
          :action => 'receiver'
        )
      end

    end
  end
end
