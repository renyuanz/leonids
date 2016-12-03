---
layout: post
title: 'Mysql::Error: query: not connected with Rails ActiveRecord'
date: 2010-09-03 13:16:50.000000000 +00:00
categories:
- Rails
tags:
- mysql
- rails
- ruby
status: publish
type: post
published: true
meta:
  _edit_last: '6'
  _sexybookmarks_shortUrl: http://b2l.me/an6z7z
  _wp_old_slug: ''
  _sexybookmarks_permaHash: 615260e1996826f1a31ed59c386afa90
  _syntaxhighlighter_encoded: '1'
author:
  login: radek.antoniuk@gmail.com
  email: radek.antoniuk@gmail.com
  display_name: warden
  first_name: r
  last_name: a
excerpt: !ruby/object:Hpricot::Doc
  options: {}
---
<p>If you run <em>rake db:migrate </em> and experience that error:<br />
[code]<br />
rake aborted!<br />
Mysql::Error: query: not connected: CREATE TABLE `schema_migrations` (`version` varchar(255) NOT NULL) ENGINE=InnoDB<br />
C:/Ruby192/lib/ruby/gems/1.9.1/gems/activerecord-3.0.0/lib/active_record/connection_adapters/abstract_adapter.rb:202:in `rescue in log'<br />
C:/Ruby192/lib/ruby/gems/1.9.1/gems/activerecord-3.0.0/lib/active_record/connection_adapters/abstract_adapter.rb:194:in `log'<br />
C:/Ruby192/lib/ruby/gems/1.9.1/gems/activerecord-3.0.0/lib/active_record/connection_adapters/mysql_adapter.rb:289:in `execute'<br />
C:/Ruby192/lib/ruby/gems/1.9.1/gems/activerecord-3.0.0/lib/active_record/connection_adapters/abstract/schema_statements.rb:167:in `create_table'<br />
C:/Ruby192/lib/ruby/gems/1.9.1/gems/activerecord-3.0.0/lib/active_record/connection_adapters/mysql_adapter.rb:445:in `create_table'<br />
C:/Ruby192/lib/ruby/gems/1.9.1/gems/activerecord-3.0.0/lib/active_record/connection_adapters/abstract/schema_statements.rb:430:in `initialize_schema_migrations_table'<br />
C:/Ruby192/lib/ruby/gems/1.9.1/gems/activerecord-3.0.0/lib/active_record/migration.rb:487:in `initialize'<br />
C:/Ruby192/lib/ruby/gems/1.9.1/gems/activerecord-3.0.0/lib/active_record/migration.rb:433:in `new'<br />
C:/Ruby192/lib/ruby/gems/1.9.1/gems/activerecord-3.0.0/lib/active_record/migration.rb:433:in `up'<br />
C:/Ruby192/lib/ruby/gems/1.9.1/gems/activerecord-3.0.0/lib/active_record/migration.rb:415:in `migrate'<br />
C:/Ruby192/lib/ruby/gems/1.9.1/gems/activerecord-3.0.0/lib/active_record/railties/databases.rake:142:in `block (2 levels) in '<br />
C:/Ruby192/lib/ruby/1.9.1/rake.rb:634:in `call'<br />
C:/Ruby192/lib/ruby/1.9.1/rake.rb:634:in `block in execute'<br />
C:/Ruby192/lib/ruby/1.9.1/rake.rb:629:in `each'<br />
C:/Ruby192/lib/ruby/1.9.1/rake.rb:629:in `execute'<br />
C:/Ruby192/lib/ruby/1.9.1/rake.rb:595:in `block in invoke_with_call_chain'<br />
C:/Ruby192/lib/ruby/1.9.1/monitor.rb:201:in `mon_synchronize'<br />
C:/Ruby192/lib/ruby/1.9.1/rake.rb:588:in `invoke_with_call_chain'<br />
C:/Ruby192/lib/ruby/1.9.1/rake.rb:581:in `invoke'<br />
C:/Ruby192/lib/ruby/1.9.1/rake.rb:2041:in `invoke_task'<br />
C:/Ruby192/lib/ruby/1.9.1/rake.rb:2019:in `block (2 levels) in top_level'<br />
C:/Ruby192/lib/ruby/1.9.1/rake.rb:2019:in `each'<br />
C:/Ruby192/lib/ruby/1.9.1/rake.rb:2019:in `block in top_level'<br />
C:/Ruby192/lib/ruby/1.9.1/rake.rb:2058:in `standard_exception_handling'<br />
C:/Ruby192/lib/ruby/1.9.1/rake.rb:2013:in `top_level'<br />
C:/Ruby192/lib/ruby/1.9.1/rake.rb:1992:in `run'<br />
C:/Ruby192/bin/rake:31:in `'[/code]<br />
then try to do this to solve the problem:</p>
<ol>
<li>download an older libmysql library dll, e.g. from <a href="http://instantrails.rubyforge.org/svn/trunk/InstantRails-win/InstantRails/mysql/bin/libmySQL.dll" target="_blank">here</a></li>
<li>put it in your rails installation directory, e.g. C:/Ruby192/bin/</li>
<li>restart the rails server</li>
</ol>
