#! /usr/bin/env ruby
# frozen_string_literal: true

require_relative 'modules/csv-module'
require_relative 'modules/settings-module'

# PwdGen
class PwdGen
  include SettingsManager
  include CsvManager

  attr_accessor :new_pwd, :last_pwd, :pwds, :settings

  def initialize
    bootstrap_settings
    @settings = load_settings[0][:settings]
    bootstrap_csv(@settings[:db_path], @settings[:headers])
    @new_pwd = pwd_gen
    @pwds = load_pwds(@settings[:db_path])
    @last_pwd = @pwds[-1] unless @pwds.empty?
  end

  def start_generator
    case main_menu
    when 1
      write_csv(@new_pwd, @settings[:db_path])
      recap
    when 2
      print "\nThe last password generated on #{last_pwd['Data']} at #{last_pwd['Ora']} is\n => #{last_pwd['Password']}"
    when 3
      @pwds.each_with_index { |x, i| print "# PWD N.#{i} => #{x['Data']} at #{x['Ora']} #{x['Password']}\n" }
    end
  end

  def pwd_gen
    @settings[:dictionary].split(//).sort_by { rand }.join[..@settings[:pwd_len]]
  end

  # def pwd_check(pwd)
  #   pwd.include?
  # end

  def recap
    print "\nThe new generated password is\n=> #{@new_pwd}\n"
    print "\nThe last password generated is \n => #{last_pwd['Password']}\n" unless last_pwd.nil?
  end

  def main_menu
    clear_term
    selection = 0
    valid_choices = (1..3).to_a
    print "Hello, welcome to Unipd Password Generator!\n\nSelect an action:\n\n"
    print "1) Generate new password\n2) View password generated\n3) List all passwords\n"
    lsel = lambda do
      print "\nAnswer (only the number!): "
      gets.chomp.to_i
    end
    selection = lsel.call until valid_choices.include? selection
    selection
  end

  def clear_term
    system 'clear'
  end
end

PwdGen.new.start_generator
