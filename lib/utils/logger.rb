require 'logger'
$logger = Logger.new(STDOUT)
$logger.level = Logger::INFO

module Logging
  def logger
    @logger ||= $logger
  end

  def log(str, severity = :info)
    logger.send(severity,"[#{self.name}] #{str}")
  end
end
