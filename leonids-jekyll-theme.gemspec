Gem::Specification.new do |s|
  s.name     = 'Leonids'
  s.version  = '0.1.0'
  s.license  = 'MIT'
  s.summary  = 'A simple and clean two columns Jekyll theme.'
  s.author   = 'Renyuan Zou'
  s.email    = 'zourenyuan@gmail.com'
  s.homepage = 'https://github.com/renyuanz/leonids'
  s.files    = `git ls-files -z`.split("\x0").grep(%r{^_(sass|includes|layouts)/})
end
