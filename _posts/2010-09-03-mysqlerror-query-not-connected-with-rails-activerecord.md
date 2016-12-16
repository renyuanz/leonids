---
layout: post
title: 'Mysql::Error: query: not connected with Rails ActiveRecord'
date: 2010-09-03 
categories:
- Administration
tags:
- mysql
- rails
- ruby
---

If you run `rake db:migrate`  and experience that error:
```
rake aborted!
Mysql::Error: query: not connected: CREATE TABLE `schema_migrations` (`version` varchar(255) NOT NULL) ENGINE=InnoDB
C:/Ruby192/lib/ruby/gems/1.9.1/gems/activerecord-3.0.0/lib/active_record/connection_adapters/abstract_adapter.rb:202:in `rescue in log'
C:/Ruby192/lib/ruby/gems/1.9.1/gems/activerecord-3.0.0/lib/active_record/connection_adapters/abstract_adapter.rb:194:in `log'
C:/Ruby192/lib/ruby/gems/1.9.1/gems/activerecord-3.0.0/lib/active_record/connection_adapters/mysql_adapter.rb:289:in `execute'
C:/Ruby192/lib/ruby/gems/1.9.1/gems/activerecord-3.0.0/lib/active_record/connection_adapters/abstract/schema_statements.rb:167:in `create_table'
C:/Ruby192/lib/ruby/gems/1.9.1/gems/activerecord-3.0.0/lib/active_record/connection_adapters/mysql_adapter.rb:445:in `create_table'
C:/Ruby192/lib/ruby/gems/1.9.1/gems/activerecord-3.0.0/lib/active_record/connection_adapters/abstract/schema_statements.rb:430:in `initialize_schema_migrations_table'
C:/Ruby192/lib/ruby/gems/1.9.1/gems/activerecord-3.0.0/lib/active_record/migration.rb:487:in `initialize'
C:/Ruby192/lib/ruby/gems/1.9.1/gems/activerecord-3.0.0/lib/active_record/migration.rb:433:in `new'
C:/Ruby192/lib/ruby/gems/1.9.1/gems/activerecord-3.0.0/lib/active_record/migration.rb:433:in `up'
C:/Ruby192/lib/ruby/gems/1.9.1/gems/activerecord-3.0.0/lib/active_record/migration.rb:415:in `migrate'
C:/Ruby192/lib/ruby/gems/1.9.1/gems/activerecord-3.0.0/lib/active_record/railties/databases.rake:142:in `block (2 levels) in '
C:/Ruby192/lib/ruby/1.9.1/rake.rb:634:in `call'
C:/Ruby192/lib/ruby/1.9.1/rake.rb:634:in `block in execute'
C:/Ruby192/lib/ruby/1.9.1/rake.rb:629:in `each'
C:/Ruby192/lib/ruby/1.9.1/rake.rb:629:in `execute'
C:/Ruby192/lib/ruby/1.9.1/rake.rb:595:in `block in invoke_with_call_chain'
C:/Ruby192/lib/ruby/1.9.1/monitor.rb:201:in `mon_synchronize'
C:/Ruby192/lib/ruby/1.9.1/rake.rb:588:in `invoke_with_call_chain'
C:/Ruby192/lib/ruby/1.9.1/rake.rb:581:in `invoke'
C:/Ruby192/lib/ruby/1.9.1/rake.rb:2041:in `invoke_task'
C:/Ruby192/lib/ruby/1.9.1/rake.rb:2019:in `block (2 levels) in top_level'
C:/Ruby192/lib/ruby/1.9.1/rake.rb:2019:in `each'
C:/Ruby192/lib/ruby/1.9.1/rake.rb:2019:in `block in top_level'
C:/Ruby192/lib/ruby/1.9.1/rake.rb:2058:in `standard_exception_handling'
C:/Ruby192/lib/ruby/1.9.1/rake.rb:2013:in `top_level'
C:/Ruby192/lib/ruby/1.9.1/rake.rb:1992:in `run'
C:/Ruby192/bin/rake:31:in `'
```

then try to do this to solve the problem:

* download an older libmysql library dll, e.g. from [here](http://instantrails.rubyforge.org/svn/trunk/InstantRails-win/InstantRails/mysql/bin/libmySQL.dll)
* put it in your rails installation directory, e.g. C:/Ruby192/bin/
* restart the rails server
