#!/usr/bin/env ruby

require 'sensu-plugin/check/cli'
require 'etc'

class UsersVoidHomedirs < Sensu::Plugin::Check::CLI
  option :path,
         short: '-p PATH',
         long: '--path PATH',
         description: 'Path to home directories',
         required: true,
         default: '/home'

  option :skip,
         short: '-s SKIP',
         long: '--skip SKIP',
         description: 'Comma separated list of directories to ignore',
         required: false,
         proc: proc { |a| a.split(',') }

  def run
    void_users = []
    Dir.foreach(config[:path]) do |user|
      next if user == '.' || user == '..' || user == 'lost+found'
      next if config[:skip] && config[:skip].include?(user)
      begin
        Etc.getpwnam(user)
      rescue
        void_users.push(user)
        next
      end
    end

    if void_users.empty?
      ok 'Homedirs OK'
    else
      warning "Void user(s) with home directory: #{void_users}"
    end
  end
end
