Gem::Specification.new do |s|
  s.name          = "ya_dir"
  s.summary       = "Yandex.Direct API wrapped in Ruby"
  s.description   = File.read(File.join(File.dirname(__FILE__), 'README'))
  s.requirements  = ['xmlsimple gem']
  s.version       = "0.0.1"
  s.author        = "Paul Repin"
  s.email         = "paul.repin@gmail.com"
  s.homepage      = "http://prepin.net"
  s.platform      = Gem::Platform::RUBY
  s.required_ruby_version = '>=1.9'
  s.files         = Dir['**/**']
  s.files.reject! { |fn| fn.include? "execution.rb" }
  s.files.reject! { |fn| fn.include? "cert" }
  s.files.reject! { |fn| fn.include? "ya_dir.gemspec" }  
  s.executables   = []
  s.test_files    = Dir["test/test*.rb"]
  s.has_rdoc      = false
endh