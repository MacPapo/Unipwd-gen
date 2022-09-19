#! /usr/bin/env ruby
# frozen_string_literal: true

require 'csv'

DB_PATH = '.db_pwd.csv'
HEADERS = "Ora,Data,Password\n"
LEN = 10

def pwd_gen
  "AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz?@()1234567890_-+<>,.".split(//).sort_by { rand }.join[..LEN]
end

def write_csv(pwd = pwd_gen)
  if File.file?(DB_PATH)
    File.write(DB_PATH, csv_pwd(pwd), mode: 'a')
  else
    File.open(DB_PATH, 'w') { |f| f.write HEADERS }
  end
end

def csv_pwd(pwd)
  CSV.generate { |csv| csv << [Time.now.strftime('%H:%M'), Time.now.strftime('%d-%m-%Y'), pwd] }
end

def read_csv
  CSV.open(DB_PATH).read
end
