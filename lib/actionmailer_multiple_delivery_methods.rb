class ActionMailer::Base
  
  # override deliver! to support multiple methods
  def deliver!(mail = @mail)
    raise "no mail object available for delivery!" unless mail
    unless logger.nil?
      logger.info  "Sent mail to #{Array(recipients).join(', ')}"
      logger.debug "\n#{mail.encoded}"
    end

    begin
      Array(delivery_method).each do |dm|
        __send__("perform_delivery_#{dm}", mail) if perform_deliveries
      end
    rescue Exception => e  # Net::SMTP errors or sendmail pipe errors
      raise e if raise_delivery_errors
    end

    return mail
  end

end