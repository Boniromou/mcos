require 'jwt'
require 'logger'

module Util
  def logger
    STDOUT.sync = true
    @logger ||= Logger.new(STDOUT)
  end

  def ensure_valid_balances!(inbound, *args)
    res = true
    args.each do |name|
      unless inbound[name] > 0
        res = false
        break
      end
    end
    res
  end

  def to_f(inbound, *arg)
    arg.each do |name|
      inbound[name] = inbound[name].to_f if inbound.include?(name)
    end
    inbound
  end

  def decode(token)
    result = JWT.decode token, 'test_key', true, { :algorithm => 'HS256' }
    symbolize(result)
  end

  def symbolize(opts)
    if opts.is_a? Hash
      return opts.inject({}) do |memo, (k, v)|
        memo.tap { |m| m[k.to_sym] = symbolize(v) }
      end
    elsif opts.is_a? Array
      return opts.map { |v| symbolize(v) }
    end
    opts
  end

  def cent2dollar(cent_amt)
    (cent_amt.to_f/100.0).to_f
  end

  def dollar2cent(dollar_amt)
    (dollar_amt.to_f*100).round
  end

  def underscore(string)
    string.scan(/[A-Z][a-z]*/).join("_").downcase
  end

  def gen_bet_ext_trans_id(fund_trans_id)
    "J" + fund_trans_id[10, 8]
  end

  def gen_fund_ext_trans_id(fund_trans_id)
    "J" + fund_trans_id[10, 14]
  end

  def timestamp
    Time.now
  end

  def random_string(length = 20)
    Array.new(length) { Array('A'..'Z').sample }.join
  end

  def logger_msg(random_key, string, params = '')
    logger.info("[#{random_key}] #{string} #{params}")
  end

  def function_log(random_key, api_name, method, start_time = timestamp)
    logger << "\n"
    logger.info("Processing #{api_name}##{method.to_s} (at #{start_time.strftime("%Y-%m-%d %H:%M:%S.%L")}) [#{random_key}]")
  end

  def response_log(random_key, response, start_time)
    logger.info("[#{random_key}] Remote #{response.request[:method]} call: #{response.request[:base_uri]}#{response.request[:path]}")
    logger.info("[#{random_key}] Header: #{response.request[:headers]}")
    logger.info("[#{random_key}] Params: #{response.request[:params]}")

    logger.info("[#{random_key}] Response time: #{timestamp - start_time}")
    logger.info("[#{random_key}] Response raw: #{response.response[:payload]}")
    data = { :code => response.code, :message => response.message, :data => response.data}
    logger.info("[#{random_key}] Response data: #{data}")
  end

  protected

  def get_expect_result_key(response)
    result = []
    response.each do | key |
      result << (key[1][:bind_to] || key[0]).to_sym
    end
    result
  end
end
