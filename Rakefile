# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")

require 'motion/project/template/ios'
require 'bundler'
Bundler.require

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'AuthExample'
  app.identifier = 'com.example.authexample'
  app.device_family = :iphone
  app.interface_orientations = [:portrait]

  # PODS
  app.pods do
    pod 'SVProgressHUD'
  end
end