#! /usr/bin/env ruby
# frozen_string_literal: true

require_relative 'modules/csv-module'
require_relative 'modules/settings-module'

# Pwd Generator class offer the main function 'start_generator' that
# act like a Main function that call 'main_menu' and select the right
# mode of the PwdGen
class PwdGen
  include SettingsManager
  include CsvManager

  attr_accessor :new_pwd, :last_pwd, :pwds, :settings

  # The PwdGen constructor initialize the enviroment for PwdGen objects
  def initialize
    # boostrap_settings creates a settings file if does not exist
    bootstrap_settings

    # @settings is filled with settings taken from settings.yaml file
    # created in the bootstrap_settings func
    @settings = load_settings[0][:settings]

    # boostrap_csv creates a hidden csv file if does not exist
    bootstrap_csv(@settings[:db_path], @settings[:headers])

    # @new_pwd contains the new password generated until the new pwd
    # satisfy the pwd_check standards! Thanks to this method all the
    # password generated from Unipwd-gen are correct for Uni criteria!!
    @new_pwd = pwd_gen until pwd_check @new_pwd

    # @pwds take all the pwds in the csv file, if there are
    @pwds = load_pwds(@settings[:db_path])

    # @last_pwd is the last pwd generated from Unipwd-gen,
    # this can be handy when you may have to insert the old pwd to
    # change the new one!!
    @last_pwd = @pwds[-1] unless @pwds.empty?
  end

  # start_generator func is the core of Unipwd-gen! Act like a mod selector
  def start_generator
    # clear_term just clear the console!
    clear_term

    # Switch case for main_menu selection
    case main_menu
    when 1
      # when main_menu answer is 1 create the new pwd and visualize it!
      # write_csv is in the csv-module.rb in module folder, update the csv
      # with the new generated pwd
      write_csv(@new_pwd, @settings[:db_path])

      # recap shows the new generated password and the old one, helping you to
      # generate the new pwd on site that also ask you with the old one before
      recap
    when 2
      # when main_menu answer is 2 just print the old password!
      date = last_pwd['Data']
      hour = last_pwd['Ora']
      pwd  = last_pwd['Password']
      print "\nThe last password generated on #{date} at #{hour} is\n => #{pwd}"
    when 3
      # when main_menu answer is 3 just list all the passwords in the csv!
      @pwds.each_with_index do |x, i|
        print "# PWD N.#{i}: #{x['Data']} at #{x['Ora']} => #{x['Password']}\n"
      end
    end
  end

  # pwd_gen generate the new pwd starting from the dictionary that can be
  # modified in the settings.yaml file!
  # The dictionary is splitted into an array containing all the characters and
  # then randomly sorted and joined from 0 to pwd_len
  # (taken also from settings.yaml file) returning back the new
  # generated password mixed of len pwd_len!
  def pwd_gen
    @settings[:dictionary].split(//).sort_by { rand }.join[..@settings[:pwd_len]]
  end

  # pwd_check use a powerfull regex to scan the new generated pwd and check for
  # conformity of the Uni standard criteria!
  def pwd_check(pwd)
    return false if pwd.nil?

    pwd.match?(/^(?=.*[a-zA-Z])(?=.*[0-9])(?=.*\W).{10,}$/)
  end

  # recap just recap the new and old passords
  def recap
    print "\nNew generated password is\n=> #{@new_pwd}\n"
    print "\nOld generated password is\n=> #{last_pwd['Password']}\n" unless last_pwd.nil?
  end

  # main_menu function ask you to insert the rigth mode to use!
  def main_menu
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

  # just clear the console out
  def clear_term
    system 'clear'
  end
end

# Just one single func has to be called! All the magic is inside
PwdGen.new.start_generator
