require 'rest_client'

module Lolcommits
  class Uploldz < Plugin
    attr_accessor :endpoint, :tumblr_endpoint, :tumblr_serve_point

    def initialize(runner)
      super

      self.name     = 'uploldz'
      self.default  = true
      stub = 'http://dev-crushing-768cb93d.ewr01.tumblr.net:9191/branchselfie'
      self.tumblr_serve_point = stub + '/files/'
      self.tumblr_endpoint = stub + '/index.php'
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

        current_stub = self.tumblr_serve_point + user + '/' + repo + '/' + branch
        puts 'See your last commit-selfie at ' + current_stub + '/current.jpg'
        puts 'See your animated selfie-series at ' + current_stub + '/current_anim.gif'

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
