require 'rack'

# Rack::Server.start(
#   app: Proc.new do |env|
#     ["200", {"Content-Type"=>"text/html"}, ["Hello Word"]]
#   end 
# )

app = Proc.new do |env|
  req = Rack::Request.new(env)
  res = Rack::Response.new 
  res["Content-Type"] = "text/html"
  # if rec.path == 
  #   path = /w*
  #   res.write(path)
  # else 
  #   res.write("Hello World!")
  # end
  res.write(req.path) 
  res.finish 
end 

Rack::Server.start(
  app: app,
  Port: 3000
)