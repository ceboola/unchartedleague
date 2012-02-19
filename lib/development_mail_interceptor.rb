class DevelopmentMailInterceptor
  def self.delivering_email(mail)
    mail.subject = "#{mail.subject} to<#{mail.to}> cc<#{mail.cc}> bcc<#{mail.bcc}>"
    mail.to = "miciek@gmail.com"
    mail.bcc = []
    mail.cc = []
  end
end 