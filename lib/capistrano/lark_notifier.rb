require 'lark_notifier/version'
require 'lark_notifier/notifier'

load File.expand_path('../tasks/lark.rake', __FILE__)

# 自動加載 hooks
namespace :load do
  task :defaults do
    # 設置默認值
    set :lark_notifier, {}
    
    # 自動添加 hooks
    after 'deploy:starting', 'lark:starting'
    after 'deploy:finished', 'lark:finished'
    after 'deploy:failed', 'lark:failed'
    
    # 記錄部署開始時間
    before 'deploy:starting', :record_deploy_start_time do
      set :deployment_started_at, Time.now
    end
  end
end