Then /^an? (warning|error|debug message|fatal error|info message|unknown) should have been logged$/ do |message_kind|
  severity = {
               'warning' => Logger::WARN, 'error' => Logger::ERROR, 
               'debug message' => Logger::DEBUG, 'info message' => Logger::INFO, 
               'fatal error' => Logger::FATAL, 'unknown' => Logger::UNKNOWN
             }[message_kind]
  @recording_logger.has_message_for_severity?(severity).should be_true
end