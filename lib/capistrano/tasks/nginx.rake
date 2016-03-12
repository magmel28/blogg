namespace :nginx do
  desc 'Setup nginx configuration'
  task :upload_config do
    on roles :web do
      upload! StringIO.new(File.read('config/nginx.conf')),
              "/tmp/#{fetch(:nginx_config_name)}"
      execute :mv,
              "/tmp/#{fetch(:nginx_config_name)} /etc/nginx/sites-available/#{fetch(:nginx_config_name)}"
      execute :ln, '-fs',
              "/etc/nginx/sites-available/#{fetch(:nginx_config_name)} /etc/nginx/sites-enabled/#{fetch(:nginx_config_name)}"
    end
  end
end