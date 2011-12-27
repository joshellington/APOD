require 'nokogiri'   
require 'open-uri'
require 'json'
require 'date'
require 'time'

def base_uri
  base_uri_raw = request.env["HTTP_HOST"]+request.env["SCRIPT_NAME"]
  path = URI.parse(request.env["REQUEST_URI"]).path
  base_uri = "http://"+base_uri_raw.split(path)[0]
end

def curr_path
  base_uri_raw = request.env["HTTP_REFERER"]
end

def match(path, opts={}, &block)
  get(path, opts, &block)
  post(path, opts, &block)
end

#

@@url = 'http://apod.nasa.gov/apod/'
@@date = Time.now.strftime("%g%m%d")

class Post

  def initialize
  end

  def self.fetch url
    doc = Nokogiri::HTML(open(url))
  end

  # def self.random
  #   doc = self.fetch('http://apod.nasa.gov/apod/archivepix.html')
  #   a = doc.css('b')[0].children.css('a')
  #   ids = []
  #   a.each do |l|
  #     puts l.values[0]
  #     ids.push(l.values[0].sub('.html',''))
  #   end
  #   ids
  #   # id = a[rand(a.size)].values[0].sub('.html','')
  #   # self.get(id)
  # end

  def self.random latest
    date1 = Date.strptime("950616", "%g%m%d").to_time
    date2 = Date.strptime(latest.to_s, "%g%m%d").to_time
    t = Time.at((date2.to_f - date1.to_f)*rand + date1.to_f).to_time
    'ap'+t.strftime("%g%m%d")
  end

  def self.get id = nil, latest = @@date
    if id.nil?
      doc = self.fetch(@@url)
    else
      doc = self.fetch(@@url+id+'.html')

      id_int = id.sub('ap','').to_i
      next_id = id_int+1;
      previous_id = id_int-1;

      puts next_id
      puts previous_id
    end

    random = self.random(latest)
    image = doc.css('img')[0].values[0]
    title = doc.css('center')[1].children.css('b')[0].text
    date = doc.css('center')[0].children.css('p')[1].text
    children = doc.css('center')[2].children
    text = doc.css('p')[2].text.sub('Explanation: ','')

    children.css('a').each do |a|
      if a.text.include? '<'
        id = a.values[0].sub('.html','')
      end
    end

    {
      :title => title,
      :image => @@url+image,
      :text => text,
      :date => date,
      :id => id,
      :random => random,
      :next => 'ap'+next_id.to_s,
      :previous => 'ap'+previous_id.to_s
    }
  end

end