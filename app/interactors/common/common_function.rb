module CommonFunction
  include Util
  include Error

  def before_run(context)
    function_log(@random_key, self.class.name.split('::').last, __method__)
    logger_msg(@random_key, 'params: ', {:params => context[:params]})
    @random_key = random_string(20)
  end

end