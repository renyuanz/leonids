# coding: utf-8

Gem::Specification.new do |spec|
  spec.name          = "leonids"
  spec.version       = "0.1.1"
  spec.authors       = ["Renyuan Zou"]
  spec.email         = ["zourenyuan@gmail.com"]

  spec.summary       = %q{A simple and clean two columns Jekyll theme.}
  spec.homepage      = "https://github.com/jekyll/leonids"
  spec.license       = "MIT"

  spec.metadata["plugin_type"] = "theme"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(exe)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }

  spec.add_development_dependency "jekyll", "~> 3.2"
  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
end
