#! /usr/bin/env ruby
# frozen_string_literal: true

require 'yaml'
require_relative 'template-module'

# SettingsManager Module
module SettingsManager
  include TemplateModule

  SETTINGS = 'settings.yaml'
  # make sure that all the file are in place
  def bootstrap_settings
    return if File.file?(SETTINGS) && !File.zero?(SETTINGS)

    ryaml = ->(x) { YAML.dump(x).gsub('--- |', '') }
    File.open(SETTINGS, 'w') { |f| f.write("--- !PWDGEN_SETTINGS\n") }
    File.write(SETTINGS, ryaml.call(SETTINGS_TEMPLATE), mode: 'a')
  end

  def load_settings
    YAML.load_file(SETTINGS, symbolize_names: true)
  end

  def clear_term
    system 'clear'
  end
end
