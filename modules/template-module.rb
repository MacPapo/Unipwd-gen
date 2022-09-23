#! /usr/bin/env ruby
# frozen_string_literal: true

# TemplateModule contains the template for settings.yaml and is used
# when the yaml file does not exist
module TemplateModule
  SETTINGS_TEMPLATE = <<~TEMPLATE
    - settings:
        dictionary: "AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz?@()1234567890_-+<>,."
        db_path: ".db_pwd.csv"
        headers: "Ora,Data,Password"
        pwd_len: 12
  TEMPLATE
end
