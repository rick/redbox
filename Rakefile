#!/usr/bin/env ruby
#
# Rakefile for redboxk.
#
# == Authors
#
# * Ben Bleything <rick@rickbradley.com>
#
# == Copyright
#
# Copyright (c) 2008 Rick Bradley
#
# This code released under the terms of the MIT license.
#

require 'rubygems'
require 'rake'
require 'spec/rake/spectask'

desc "run rspec specs"
Spec::Rake::SpecTask.new( :spec ) do |r|
        r.libs      = Dir[File.expand_path(File.dirname(__FILE__) + '/spec/') + '/**/*_spec.rb']
        r.spec_opts = %w(-o spec/spec.opts)
end

# load all rake tasks
Dir[File.dirname(__FILE__) + '/tasks/*.rake'].each do |rakefile|
  load rakefile
end

task :default => [ :spec ]
