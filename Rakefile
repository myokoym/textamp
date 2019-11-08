desc 'compile into js'
task :default do
  sh 'bundle exec opal -I . -c -g ovto app.rb > app.js'
end

desc 'start auto-compiling'
task :watch do
  sh 'ifchanged app.rb components/*.rb -d "bundle exec rake"'
end
