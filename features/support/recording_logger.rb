require 'logger'

class RecordingLogger < Logger
  def recorded_messages
    @recorded_messages ||= {}
  end
  
  alias_method :add_original, :add
  def add(severity, message = nil, progname = nil, &block)
    record_it(severity, message)
    super
  end
  
  
  def reset_recorder!
    @recorded_messages = {}
  end
  
  def has_message_for_severity?(severity)
    (!recorded_messages[severity].nil? && !recorded_messages[severity].empty?)
  end
  
  private
  
  def record_it(severity, message)
    (recorded_messages[severity] ||= []) << message
  end
end