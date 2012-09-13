require 'sinatra'
require 'cgi'
require 'watir-webdriver'

class GoogleImage

  def initialize
    @browser = Watir::Browser.new
  end
  
  def first_photo_url(url)
    url.strip!
    @browser.goto 'http://www.google.com/imghp?hl=ru&tab=wi'
    @browser.span(:id, 'qbi').click
    @browser.text_field(:id, 'qbui').set(url)
    @browser.form(:id,'qbf').submit
    @browser.div(:id, 'topstuff').img.click
    src = @browser.a(:class, 'rg_l').href
    CGI.parse(URI(src).query)['imgurl'].first
  rescue
    nil
  end

end

get %r{/launder/(.+)}  do |url|
  @@google ||= GoogleImage.new
  @@google.first_photo_url(url)
end

