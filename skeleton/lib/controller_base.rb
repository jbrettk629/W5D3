require 'active_support'
require 'active_support/core_ext'
require 'active_support/inflector'
require 'erb'
require_relative './session'

class ControllerBase
  attr_reader :req, :res, :params

  # Setup the controller
  def initialize(req, res)
    @req = req
    @res = res
    @already_built_response = false
  end

  # Helper method to alias @already_built_response
  def already_built_response?
    @already_built_response
  end

  # Set the response status code and header
  def redirect_to(url)
    raise if already_built_response?
    @res["Location"] = url
    @res.status = 302
    @already_built_response = true
    nil
  end

  # Populate the response with content.
  # Set the response's content type to the given type.
  # Raise an error if the developer tries to double render.
  # ["200", {"Content-Type"=>"text/html"}, ["Hello Word"]]
  def render_content(content, content_type = "text/html")
    raise if already_built_response?
    @res.write(content)
    @res['Content-Type'] = content_type
    @already_built_response = true
    nil
  end

  # use ERB and binding to evaluate templates
  # pass the rendered html to render_content
  
  # "views/#{controller_name}/#{template_name}.html.erb"
  def render(template_name)
    dir_path = File.dirname(__FILE__).split("/")[0..-2].join("/")
    class_name = self.class.to_s.underscore
    template_path = File.join(dir_path,"views",class_name,"#{template_name}.html.erb")
    template_code = File.read(template_path)
    render_content(ERB.new(template_code).result(binding))    
  end

  # method exposing a `Session` object
  def session
  end

  # use this with the router to call action_name (:index, :show, :create...)
  def invoke_action(name)
  end
end

