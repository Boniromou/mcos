module CommonFunction
  include Util
  include Error

  def before_run(context)
    function_log(@random_key, self.class.name.split('::').last, __method__)
    logger_msg(@random_key, 'params: ', {:params => context[:params]})
    @random_key = random_string(20)
  end

  def decode_player_token(context)
    function_log(@random_key, self.class.name.split('::').last, __method__)
    context[:player_info], header = decode(context[:params][:player_token])
  end

  def handle_decode_token_fail(context)
    function_log(@random_key, self.class.name.split('::').last, __method__)
    context[:result] = InvalidPlayerToken.new(context) if context[:failed_task].name == :decode_player_token
  end
end
