# encoding: utf-8

##
# Backup Generated: fdf_12_development
# Once configured, you can run the backup with the following command:
#
# $ backup perform -t fdf_12_development [-c <path_to_configuration_file>]
#
# For more information about Backup's components, see the documentation at:
# http://backup.github.io/backup
#
require "yaml"
app_config = YAML.load_file("./config/application.yml")
Model.new(:fdf_12_development, "Description for db_backup") do
  database MySQL do |db|
    # To dump all databases, set `db.name = :all` (or leave blank)
    db.name = "fdf_12_development"
    db.username = "root"
    db.password = "xuanpham"
    db.host = "localhost"
    db.port = 3306
    db.socket = "/var/run/mysqld/mysqld.sock"
  end
  ##
  # SCP (Secure Copy) [Storage]
  #
  store_with Local do |local|
  local.path = "~/backups/"
  # Use a number or a Time object to specify how many backups to keep.
  local.keep = 5
end
store_with Dropbox do |db|
  db.api_key = "4lyjy9ct1bosd78"
  db.api_secret  = "0yyweym9ivfnhao"
  # Sets the path where the cached authorized session will be stored.
  # Relative paths will be relative to ~/Backup, unless the --root-path
  # is set on the command line or within your configuration file.
  db.cache_path  = ".cache"
  # :app_folder (default) or :dropbox
  db.access_type = :app_folder
  db.path = "/path/to/my/backups"
  # Use a number or a Time object to specify how many backups to keep.
  db.keep = 25
end
  ##
  # Gzip [Compressor]
  #
  compress_with Gzip
  ##
  # Mail [Notifier]
  #
  # The default delivery method for Mail Notifiers is 'SMTP'.
  # See the documentation for other delivery options.
  #
  notify_by Mail do |mail|
    mail.on_success = true
    mail.on_warning = true
    mail.on_failure = true
    mail.from = app_config["FORDER_EMAIL_USERNAME"]
    mail.to = app_config["FORDER_EMAIL_USERNAME"]
    mail.address = app_config["FORDER_EMAIL_ADDRESS"]
    mail.port = 587
    mail.domain = app_config["HOST_NAME"]
    mail.user_name = app_config["FORDER_EMAIL_USERNAME"]
    mail.password = app_config["FORDER_EMAIL_PASSWORD"]
  end
end
