namespace :deploy do
  desc 'Make sure local git is in sync with remote.'
  task :check_revision do
    on roles(:app) do
      unless `git rev-parse HEAD` == `git rev-parse origin/master`
        puts 'WARNING: HEAD is not the same as origin/master'
        puts 'Run `git push` to sync changes.'
        exit
      end
    end
  end

  desc 'Upload YAML files.'
  task :upload_yml do
    on roles(:app) do
      execute "mkdir #{shared_path}/config -p"
      upload! StringIO.new(File.read('config/database.yml')), "#{shared_path}/config/database.yml", via: :scp
      upload! StringIO.new(File.read('config/application.yml')), "#{shared_path}/config/application.yml", via: :scp
    end
  end

  before :deploy, 'deploy:check_revision'
end