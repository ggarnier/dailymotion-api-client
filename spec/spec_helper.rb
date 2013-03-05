# -*- encoding: utf-8 -*-
ENV['RACK_ENV'] ||= 'test'

$:.unshift(File.join(File.dirname(__FILE__), "..", "lib"))

require 'rspec'
require 'dailymotion-api-client'
