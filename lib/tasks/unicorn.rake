# Unicorn コマンドタスク
# rake unicorn:start
# rake unicorn:stop

namespace :unicorn do
  ##
  # Tasks
  ##
  desc "Start unicorn for development env."
  task(:start) {
    env = ENV['RAILS_ENV']
    if env.blank?
      env = 'development'
    end
    config = Rails.root.join('config', 'unicorn.conf.rb')
    sh "bundle exec unicorn_rails -c #{config} -E #{env} -D"
  }

  desc "Stop unicorn"
  task(:stop) { unicorn_signal :QUIT }

  desc "Restart unicorn with USR2"
  task(:restart) { unicorn_signal :USR2 }

  desc "Increment number of worker processes"
  task(:increment) { unicorn_signal :TTIN }

  desc "Decrement number of worker processes"
  task(:decrement) { unicorn_signal :TTOU }

  desc "Unicorn pstree (depends on pstree command)"
  task(:pstree) do
    sh "pstree '#{unicorn_pid}'"
  end

  def unicorn_signal signal
    Process.kill signal, unicorn_pid
  end

  def unicorn_pid
    begin
      env = ENV['RAILS_ENV']
      if env.blank? || env == 'development'
        File.read("/tmp/unicorn.pid").to_i
      elsif env == 'staging'
        File.read("/home/nowall.inc/current/tmp/pids/unicorn.pid").to_i
      elsif env == 'production'
        File.read("/tmp/unicorn.pid").to_i
      end
    rescue Errno::ENOENT
      raise "Unicorn doesn't seem to be running"
    end
  end

end