require 'fileutils'

Before("@db") do |scenario|
  require 'active_record'
  require 'url_keyed_object/active_record'

  @db_dir = ::Dir.mktmpdir
  begin
    # Create the SQLite database, pretend the Railtie has run...
    @recording_logger = RecordingLogger.new($stderr)

    ActiveRecord::Base.extend UrlKeyedObject::ActiveRecord
    ActiveRecord::Base.establish_connection({'adapter' => 'sqlite3',
    'database' => "#{@db_dir}/feature.sqlite3", 'pool' => 5, 'timeout' => 5000
    })
    ActiveRecord::Base.connection
    ActiveRecord::Base.logger = @recording_logger
  rescue
    $stderr.puts $!, *($!.backtrace)
    $stderr.puts "Couldn't create database for #{"#{@db_dir}/feature.sqlite3".inspect}"
  end
end

After("@db") do |scenario|
  ActiveRecord::Base.connection.disconnect!
  FileUtils.remove_entry_secure @db_dir
  @recording_logger.reset_recorder!
end
