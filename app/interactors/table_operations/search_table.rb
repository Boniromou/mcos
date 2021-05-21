require 'ulid'
module PAMS
  module Interactors
    module PatronOperations
      class SearchTable < Citrine::Operation
        include CommonFunction
        include Error

        class Success < Citrine::Operation::Success
          data do |ctx|
            { 
              tables: ctx[:tables]
            }
          end
        end

        repository_alias :mcos_repository

        pass :before_run
        pass :search_table

        def search_player(context)
          context[:tables]
        end

        def search_player(context)
            context[:player] = cms_delegator_integrator.get_player_info({
              id_type: "member_id",
              id_value: context[:params][:login_name],
              licensee_id: context[:licensee_id]
            })
            logger_msg(@random_key, context[:player].data[:error_code])
        
            if context[:player].data[:error_code] != "OK"
              context[:result] = SearchPlayerFail.new(context)
            end
           
            if context[:pams_player].type == "Frontier"
              context[:verify_member] = operator_integrator.verify_member(context[:licensee_id], 
                    { member_id: context[:params][:login_name], licensee_id: context[:licensee_id]}) 
            
              if context[:verify_member].data[:error_code] != "OK"
                context[:result] = VerifyPlayerFail.new(context)
                return false
              end
        
              context[:player].data[:player][:phone_num] = context[:verify_member].data[:phone_number]
            end
            context[:timezone] = get_licensee_time_zone(context[:licensee_id])
            context[:player].data[:player][:last_sign_in] = context[:pams_player].last_sign_in.in_time_zone(context[:timezone]).strftime("%Y-%m-%d %H:%M:%S %z")
          end
 
      end
    end
  end
end