#! /usr/bin/env ruby
# frozen_string_literal: true

require 'yaml'
require_relative 'template-module'

# SettingsManager Module manage the settings.yaml file that contains
# all the customizable settings
module SettingsManager
  include TemplateModule

  SETTINGS = 'settings.yaml'

  # bootstrap_settings creates the settings.yaml file if does not exist
  def bootstrap_settings
    return if File.file?(SETTINGS) && !File.zero?(SETTINGS)

    ryaml = ->(x) { YAML.dump(x).gsub('--- |', '') }
    File.open(SETTINGS, 'w') { |f| f.write("--- !PWDGEN_SETTINGS\n") }
    File.write(SETTINGS, ryaml.call(SETTINGS_TEMPLATE), mode: 'a')
  end

  # load_settings load from settings.yaml all the custom settings
  def load_settings
    YAML.load_file(SETTINGS, symbolize_names: true)
  end

  # just clear the screen
  def clear_term
    system 'clear'
  end
end
