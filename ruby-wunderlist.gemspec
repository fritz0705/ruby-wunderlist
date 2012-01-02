lib = File.expand_path("../lib/", __FILE__)
$:.unshift lib unless $:.include?(lib)

Gem::Specification.new do |s|
  s.name          = "ruby-wunderlist"
  s.version       = "0.3"
  s.summary       = "Wunderlist Bindings for Ruby"
  s.authors       = ["Fritz Grimpen"]
  s.email         = "fritz+wunderlist@grimpen.net"
  s.files         = Dir["lib/**/*.rb"]
  s.require_path  = "lib"
  s.platform      = Gem::Platform::RUBY
  s.homepage      = "http://grimpen.net/wunderlist"
  s.license       = "MIT"

  s.add_runtime_dependency "json"
  s.add_runtime_dependency "nokogiri"
end
