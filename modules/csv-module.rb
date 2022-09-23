#! /usr/bin/env ruby
# frozen_string_literal: true

require 'csv'

# CsvManager Module manage the hidden csv file that store all the pwds
module CsvManager
  # boostrap_csv creates the hidden csv file if does not exist
  def bootstrap_csv(db, headers)
    return if File.file?(db) && !File.zero?(db)

    File.open(db, 'w') { |f| f.write "#{headers}\n" }
  end

  # Update the csv with the new generated pwd
  def write_csv(pwd, file)
    File.write(file, csv_pwd(pwd), mode: 'a')
  end

  # csv_pwd generate the csv object from a template
  def csv_pwd(pwd)
    hour = Time.now.strftime('%H:%M')
    date = Time.now.strftime('%d-%m-%Y')
    CSV.generate { |csv| csv << [hour, date, pwd] }
  end

  # load_pwds load from the csv file all the records
  def load_pwds(file)
    f = CSV.open(file, headers: true).read
    return [] if f.empty?

    f
  end
end
