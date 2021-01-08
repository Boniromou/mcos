module MCOS
  module Jobs
    class SubmitRating < Citrine::Runner::Job::CatchUp
      attr_reader :pending

      def no_more_new?
        pending <= 0
      end

      def caught_up?
        success? and no_more_new?
      end

      protected

      def set_default_options
        @default_options ||= super.merge!(
                                limit: 10,
                                wait: "5s"
                              )
      end

      def reset_states
        super
        reset_dataset
      end

      def reset_dataset
        @pending = 0
      end

      def update_states
        update_dataset
      end

      def update_dataset
        @pending = result.data[:pending] || 0
      end

      def update_summary_for_submit_rating
        if pending > 0
          @summary += "There are #{pending} pending transaction need to retry. "
        else
          @summary += "No pending transaction with 30 second. "
        end
        @summary += "Wait for #{options[:wait]} secs before next run."
      end
    end
  end
end
