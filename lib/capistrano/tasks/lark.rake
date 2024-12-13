# lib/capistrano/tasks/lark.rake
namespace :lark do
  def notifier
    config = fetch(:lark_notifier, {})
    @notifier ||= Capistrano::LarkNotifier::Notifier.new(config)
  end

  task :starting do
    title = "🚀 Start Deploying"
    content = [
      "**Project**: #{fetch(:application)}",
      "**Branch**: #{fetch(:branch)}",
      "**Stage**: #{fetch(:stage)}",
      "**Deployer**: #{ENV['USER'] || 'unknown'}"
    ].join("\n")
    notifier.send_notification(title, content, 'warning')
  end

  task :finished do
    title = "✅ Deploy Success"
    content = [
      "**Project**: #{fetch(:application)}",
      "**Branch**: #{fetch(:branch)}",
      "**Stage**: #{fetch(:stage)}",
      "**Deployer**: #{ENV['USER'] || 'unknown'}",
      "**Deploy Time**: #{(Time.now - fetch(:deployment_started_at, Time.now)).to_i} seconds"
    ].join("\n")
    notifier.send_notification(title, content, 'success')
  end

  task :failed do
    title = "❌ Deploy Failed"
    content = [
      "**Project**: #{fetch(:application)}",
      "**Branch**: #{fetch(:branch)}",
      "**Stage**: #{fetch(:stage)}",
      "**Deployer**: #{ENV['USER'] || 'unknown'}",
      "Please check the deployment log for more information"
    ].join("\n")
    notifier.send_notification(title, content, 'error')
  end

  desc 'Test Lark notification'
  task :test do
    title = "🔍 Test Notification"
    content = [
      "**Project**: #{fetch(:application)}",
      "**Test Time**: #{Time.now.strftime('%Y-%m-%d %H:%M:%S')}",
      "**Stage**: #{fetch(:stage)}",
      "This is a test message to check if the notification function is working."
    ].join("\n")
    notifier.send_notification(title, content)
  end
end