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

# 最初に参照するフォルダの指定
require File.expand_path(File.dirname(__FILE__) + "/environment")
# 現在の環境をrails_envに変数で入れている
rails_env = Rails.env.to_sym
# 実行する環境の指定
set :environment, rails_env
# ログを残すため
set :output, 'log/cron.log'
# １２時間おき
every 12.hour do
  begin
    # ファイルの実行
    runner "Batch::DataReset.data_reset"
  rescue => e
    # エラーが出たらログに記述
    Rails.logger.error("runnerがエラーを起こしました")
    # エラーの中身
    raise e
  end
end