#! /usr/bin/env ruby
require 'rake'

task :default => [ :install, :run ]

task :install do
  sh 'gem build   *.gemspec'
  sh 'gem install *.gem'
end

task :run, :channel do |t, args|
  if args[:channel]
    sh "descartes -n Descartes -s irc.rizon.net -c #{args[:channel]}"
  else
    sh 'descartes'
  end
end