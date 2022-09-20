#! /usr/bin/env ruby
# frozen_string_literal: true

require 'csv'

# CsvManager Module
module CsvManager
  def bootstrap_csv(db, headers)
    return if File.file?(db) && !File.zero?(db)

    File.open(db, 'w') { |f| f.write "#{headers}\n" }
  end

  def write_csv(pwd, file)
    File.write(file, csv_pwd(pwd), mode: 'a')
  end

  def csv_pwd(pwd)
    CSV.generate { |csv| csv << [Time.now.strftime('%H:%M'), Time.now.strftime('%d-%m-%Y'), pwd] }
  end

  def load_pwds(file)
    f = CSV.open(file, headers: true).read
    return [] if f.empty?

    f
  end
end
