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

# load all rake tasks
Dir[File.dirname(__FILE__) + '/tasks/*.rake'].each do |rakefile|
  load rakefile
end

task :default => [ :spec ]
