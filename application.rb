
require 'net/http'

class ChavSpeak
  
  def load
    @cached ||= Merb::Cache[:default].fetch("chavspeak", :interval => 300) do
      response = Net::HTTP.post_form URI.parse('http://www.text118118.com/data/livefeed_test.aspx'), {"timePerQuestion"=>"50"}
      response.body
    end
    @data = CGI.unescape(@cached.split('&').last.split('=').last).split("|").collect{ |t| t.split(";;") }.collect
  end
  
  def random
    @data[rand(@data.size)]
  end
  
end


class Chav < Merb::Controller

  def _template_location(action, type = nil, controller = controller_name)
    controller == "layout" ? "layout.#{action}.#{type}" : "#{action}.#{type}"
  end

  def index
    
    c = ChavSpeak.new
    c.load
    qa = c.random
    
    @question, @answer = c.random
    
    render 
  end
  
end