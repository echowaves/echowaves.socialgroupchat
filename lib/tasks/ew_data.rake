namespace :ew do
  namespace :db do
    desc "recreate database from scratch, similar to db:reset, but different"
    task :reset do
      Rake::Task['db:drop:all'].invoke
      Rake::Task['db:create:all'].invoke
      Rake::Task['db:migrate'].invoke
      Rake::Task['db:seed'].invoke
      Rake::Task['db:test:clone'].invoke
      
      sh %{bundle exec annotate}
    end  
  end
end