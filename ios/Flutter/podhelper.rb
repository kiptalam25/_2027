#!/usr/bin/env ruby
require 'json'
require 'fileutils'

def flutter_root
  File.expand_path(File.join('..', '..'))
end

def flutter_ephemeral_dir
  File.expand_path(File.join(flutter_root, 'bin', 'cache', 'artifacts', 'engine', 'ios'))
end

def flutter_ios_podspec
  File.expand_path(File.join(flutter_root, 'packages', 'flutter', 'ios', 'flutter.podspec'))
end

def install_flutter_pods
  engine_dir = flutter_ephemeral_dir
  framework_dir = File.expand_path(File.join(engine_dir, 'Flutter.framework'))
  raise "Flutter.framework not found at #{framework_dir}" unless Dir.exist?(framework_dir)

  pod 'Flutter', :path => File.join(flutter_root, 'bin', 'cache', 'artifacts', 'engine', 'ios')
end
