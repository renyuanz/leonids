# coding: utf-8

Gem::Specification.new do |spec|
  spec.name          = "leonids"
  spec.version       = "0.2.0"
  spec.authors       = ["Renyuan Zou"]
  spec.email         = ["zourenyuan@gmail.com"]

  spec.summary       = %q{A simple and clean two columns Jekyll theme.}
  spec.homepage      = "https://github.com/jekyll/leonids"
  spec.license       = "MIT"

  spec.metadata["plugin_type"] = "theme"

  spec.files         = `git ls-files -z`.split("\x0").select do |f|
    f.match(%r{^(assets|_(includes|layouts|sass)/|(LICENSE|README)((\.(txt|md|markdown)|$)))}i)
  end

  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }

  spec.post_install_message = <<-msg
----------------------------------------------
Thank you for installing leonids 0.2.0!
Leonids 0.2.0 comes with a breaking change that
renders '<your-site>/css/main.scss' redundant.
That file is now bundled with this gem as
'<leonids>/assets/main.scss'.
More Information:
https://github.com/jekyll/leonids#customization
----------------------------------------------
msg

  spec.add_development_dependency "jekyll", "~> 3.3"
  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
end
