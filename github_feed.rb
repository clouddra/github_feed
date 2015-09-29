require 'http'

class GithubFeed
  attr_reader :repo_name

  def initialize(repo_name)
    @repo_name = repo_name
  end

  def recent_comments
    puts "empty #{HTTP.get(url).to_s}"
    event = JSON.parse(HTTP.get(url).to_s)
    comments = event.map do |event|
      if event['type'] == 'IssueCommentEvent'
        "#{fmt_date(event['created_at'])} #{event['actor']['login']} made a comment on Issue ##{event['payload']['issue']['id']} at #{event['payload']['issue']['url']}"
      end
    end
    comments.compact.join('\n')
  end

  private
  def url
    "https://api.github.com/repos/#{repo_name}/events"
  end

  def fmt_date(date)
    Date.parse(date).strftime('%d %b %Y')
  end

end
