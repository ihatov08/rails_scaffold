# config valid only for current version of Capistrano
lock "3.7.1"

set :application, "rails_scaffold"
set :repo_url, "git@github.com:ihatov08/rails_scaffold.git"
set :keep_releases, 5
set :ssh_options, {
    forward_agent: true,
    keys: %w(/home/tomoya/.ssh/id_rsa),
    auth_methods: %w(publickey password),
    password: '401147'
}

set :log_level, :debug

set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets}

set :rbenv_type, :user # :system or :user
set :rbenv_ruby, '2.3.0'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_roles, :all # default value
# set :default_env, {
#     SECRET_KEY_BASE: ENV["SECRET_KEY_BASE"]
# }

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, "/var/www/my_app_name"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, "config/database.yml", "config/secrets.yml"

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5
after 'deploy:publishing', 'deploy:restart'
namespace :deploy do
  task :restart do
    invoke 'unicorn:restart'
  end
end
