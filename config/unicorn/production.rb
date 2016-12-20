@app_path = '/home/tomoya/rails'
working_directory @app_path + "/current"
$app_dir = "/home/tomoya/rails/rails_scaffold" #worker_processes Integer(ENV["WEB_CONCURRENCY"] || 3)
preload_app true
timeout 30
listen "#{@app_path}/current/tmp/sockets/.unicorn.sock", :backlog => 64
pid "#{@app_path}/current/tmp/pids/unicorn.pid"

stderr_path "#{@app_path}/shared/log/unicorn.stderr.log"
stdout_path "#{@app_path}/shared/log/unicorn.stdout.log"
  # loading booster
preload_app true
# before starting processes
before_fork do |server, worker|
  defined?(ActiveRecord::Base) and ActiveRecord::Base.connection.disconnect!
  old_pid = "#{server.config[:pid]}.oldbin"
  if old_pid != server.pid
    begin
      Process.kill "QUIT", File.read(old_pid).to_i
    rescue Errno::ENOENT, Errno::ESRCH
    end
  end
end
# after finishing processes
after_fork do |server, worker|
  defined?(ActiveRecord::Base) and ActiveRecord::Base.establish_connection
end