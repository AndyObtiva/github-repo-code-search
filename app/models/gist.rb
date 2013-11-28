class Gist < ActiveRecord::Base
  attr_accessible :filename, :language, :content_type, :raw_url, :size, :content
  searchable do
    text :filename, :language, :content_type, :content
    integer :size
    time :created_at
  end
  REGEX_RAW_URL = /https\:\/\/gist\.github\.com\/([^\/]+)\/([^\/]+)\/([^\/]+)\/([^\/]+)/

  def gist_id
    REGEX_RAW_URL.match(raw_url)[2]
  end

  def username
    REGEX_RAW_URL.match(raw_url)[1]
  end

  def actual_url
    "https://gist.github.com/#{username}/#{gist_id}"
  end

  def embed_url
    "https://gist.github.com/#{username}/#{gist_id}.js"
  end
end