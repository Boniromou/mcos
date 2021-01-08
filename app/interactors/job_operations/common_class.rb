module MCOS
  module Interactors
    module JobOperations
      class CommonClass < Citrine::Operation
        include CommonFunction

        class Success < Citrine::Operation::Success
          data do |ctx| { 
              result: ctx[:result_count]
            }
          end
        end

        pass :before_run
        pass :init_jobs

        def on_init(context); end
        def validate(context); end
        def post_init(context); end

        def init_jobs(context)
          on_init(context)
          validate(context)
          post_init(context)
        end
      end
    end
  end
end
