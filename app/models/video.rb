require 'elasticsearch/model'
class Video < ActiveRecord::Base
	validates :link, presence: true
	before_create :check_link
	include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

	def check_link
		video = VideoInfo.new(self.link)
		self.title = video.title
		self.duration = parse_duration(video.duration)
		self.author = video.author
		if video.provider == "YouTube"
	    video_id = self.link.split("=").last
	    self.embed_link = "//www.youtube.com/embed/" + video_id
	  end
    self
  end

  def parse_duration(d)
    hr = (d / 3600).floor
    min = ((d - (hr * 3600)) / 60).floor
    sec = (d - (hr * 3600) - (min * 60)).floor

    hr = '0' + hr.to_s if hr.to_i < 10
    min = '0' + min.to_s if min.to_i < 10
    sec = '0' + sec.to_s if sec.to_i < 10

    hr.to_s + ':' + min.to_s + ':' + sec.to_s
  end

  def self.search(query)
    __elasticsearch__.search(
      {
        query: {
          multi_match: {
            query: query,
            fields: ['title', 'author']
          }
        }
      }
    )
  end
end
