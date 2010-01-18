require 'fileutils'
Before("@db") do |scenario|
  require 'activerecord'
  @db_dir = ::Dir.mktmpdir
  begin
    # Create the SQLite database
    ActiveRecord::Base.establish_connection({'adapter' => 'sqlite3',
    'database' => "#{@db_dir}/feature.sqlite3", 'pool' => 5, 'timeout' => 5000
    })
    ActiveRecord::Base.connection
  rescue
    $stderr.puts $!, *($!.backtrace)
    $stderr.puts "Couldn't create database for #{"#{@db_dir}/feature.sqlite3".inspect}"
  end
end

After("@db") do |scenario|
  ActiveRecord::Base.connection.disconnect!
  FileUtils.remove_entry_secure @db_dir
end