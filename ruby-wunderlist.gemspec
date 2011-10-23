lib = File.expand_path("../lib/", __FILE__)
$:.unshift lib unless $:.include?(lib)

Gem::Specification.new do |s|
  s.name          = "ruby-wunderlist"
  s.version       = "0.1.pre"
  s.summary       = "Wunderlist Bindings for Ruby"
  s.authors       = ["Fritz Grimpen"]
  s.email         = "fritz+wunderlist@grimpen.net"
  s.files         = Dir["lib/**/*.rb"]
  s.require_path  = "lib"
  s.platform      = Gem::Platform::RUBY

  s.add_runtime_dependency "json"
  s.add_runtime_dependency "nokogiri"
end
