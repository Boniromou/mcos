module TMS
  module Interactors
    module AdminOperations
      class Check < Citrine::Operation
        class Success < Citrine::Operation::Success
          data do |ctx| 
            { service: 'InternalWalletService' }
          end
        end

        pass :return
        def return(context)
          true
        end
      end
    end
  end
end
