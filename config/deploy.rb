# http://warpspire.com/tipsresources/application-development/deploying-merb-with-git-vlad-the-deployer-and-ubuntu-fiesty-fawn/

namespace :vlad do
  ##
  # Merb app server

  set :application, "livsey.org"
  set :domain,      "livsey.org"
  set :deploy_to,   "/var/www/chav"
  set :repository,  "/var/git/chav"

  set :merb_address,       "127.0.0.1"
  set :merb_clean,         false
  set :merb_command,       'merb'
  set :merb_conf,          nil
  set :merb_extra_config,  nil
  set :merb_environment,   "production"
  set :merb_group,         nil
  set :merb_port,          4000
  set :merb_prefix,        nil
  set :merb_servers,       1
  set :merb_user,          nil

  desc "Prepares application servers for deployment. merb configuration is set via the merb_* variables.".cleanup

  remote_task :setup_app, :roles => :app do
    "rake"
  end

  def merb(cmd) # :nodoc:
    "cd #{current_path} && #{merb_command} -p #{merb_port} -c #{merb_servers} -e #{merb_environment} #{cmd}"
  end

  desc "Restart the app servers"

  remote_task :start_app, :roles => :app do
    run merb('')
    run "touch #{release_path}/tmp/restart.txt"
  end

  remote_task :start_app => :stop_app
  
  desc "Stop the app servers"

  remote_task :stop_app, :roles => :app do
    run merb("-K all")
  end

end

task :deploy => ["vlad:update", "vlad:start_app"]
