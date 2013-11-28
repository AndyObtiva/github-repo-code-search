require 'httparty'
namespace :index do
  desc "Index GitHub Gists for GITHUB_USERS (comma separated GitHub usernames)"
  task :github, [:GITHUB_USERS] => [:environment] do |_, args|
    Rails.logger.info "Deleting previously stored gists..."
    Gist.destroy_all
    users = (args[:GITHUB_USERS] || ENV['GITHUB_USERS']).to_s.split(',')
    users.each do |user|
      ActiveRecord::Base.transaction do
        info_message = "Processing gists for user: #{user}"
        puts info_message
        Rails.logger.info info_message
        begin
          Github::Gists.new.list(user: user).to_a.each do |gist|
            gist.files.to_a.each do |file|
              gist_file = file[1]
              info_message = "Processing: #{gist_file.filename}"
              puts info_message
              Rails.logger.info info_message

              content = nil
              begin
                content = HTTParty.get(gist_file.raw_url).body
              rescue => e
                warn_message = "Error retrieving body for gist: #{gist_file.filename}\n#{e.message}\n#{e.backtrace.join("\n")}"
                puts warn_message
                Rails.logger.warn warn_message
              end

              Gist.create!(
                filename: gist_file.filename,
                language: gist_file.language,
                content_type: gist_file.type,
                raw_url: gist_file.raw_url,
                size: gist_file.size,
                content: content
              )
            end
          end
        rescue => e
          warn_message = "Error processing GitHub gists for user:\n#{e.message}\n#{e.backtrace.join("\n")}"
          puts warn_message
          Rails.logger.warn warn_message
        end
      end
    end
  end
end