require_relative '../github_feed'

RSpec.describe GithubFeed do
  let(:repo_name) { 'rails/rails' }
  subject(:feed) { GithubFeed.new(repo_name) }

  describe '#initialize' do
    it 'works' do
      expect(feed.repo_name).to eq 'rails/rails'
    end
  end

  describe '#recent_comments' do
    before do
      stub_request(:get, "https://api.github.com/repos/#{repo_name}/events").
        with(:headers => {'Connection'=>'close', 'Host'=>'api.github.com', 'User-Agent'=>'http.rb/0.9.7'}).
        to_return(:status => 200, :body => File.open('spec/fixtures/events.json'), :headers => {})
      # allow(HTTP).to receive(:get) { File.read('spec/fixtures/events.json') }
    end
    it 'prints from api' do
      comments = feed.recent_comments
      expect(comments).to match '29 Sep 2015 deeTEEcee made a comment on Issue #54359675'
    end
  end

  describe '#url' do
    context 'for repo sinatra/sinatra' do
      let(:repo_name) { 'sinatra/sinatra' }
      it { expect(feed.send :url).to eq "https://api.github.com/repos/sinatra/sinatra/events" }
    end
  end
end
