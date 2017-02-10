set :environment, "development"
# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

job_type :envcommand, 'cd :path && RAILS_ENV=:environment :task :output'
 every 1.day, at: '18:05 pm ' do
   envcommand 'backup perform -t fdf_12_development -c ./config/backup/config.rb'
 end
