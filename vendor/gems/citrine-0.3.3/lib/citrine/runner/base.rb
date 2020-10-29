# frozen-string-literal: true
require_relative "job"

module Citrine
  module Runner
    class Base < Actor
      using CoreRefinements

      attr_reader :jobs

      def add_jobs(jobs)
        if jobs.is_a?(Hash)
          add_jobs(
            jobs.inject([]) do |j, (name, opts)|
              j.concat(opts[:jobs].map { |job|
                { name: name }.merge!(opts[:general] || {}).deep_merge!(job)
              })
            end
          )
        elsif jobs.is_a?(Array)
          jobs.each { |job| add_job(job) }
        else
          raise ArgumentError, "Invalid jobs: #{jobs.inspect}"
        end
        true
      rescue StandardError => e
        handle_exception(e)
        false
      end

      def run_job(id, wait: nil)
        return unless has_job?(id) and applicable_job?(jobs[id])
        if wait.nil? or wait <= 0
          run_job!(id)
        else
          self.after(wait) { run_job!(id) }
        end
      rescue StandardError =>e
        handle_exception(e)
      end

      def remove_job(id)
        jobs.delete(id)
      end

      def remove_jobs(*ids)
        ids.each { |id| remove_job(id) }
      end

      def has_job?(id)
        jobs.has_key?(id)
      end

      def applicable_job?(job)
        @job_filter.call(job.to_h)
      end

      def find_jobs(**opts)
        jobs.transform_values(&:to_h).select do |id, job|
          opts.reduce(true) { |found, (k, v)| found && job[k] == v }
        end
      end

      protected

      def on_init
        @jobs = {}
        @job_filter = parse_job_filter
      end

      def parse_job_filter
        filter_opts = (options[:job_filter] || "").split(":")
        filter, key, value = 
          case filter_opts.size
          when 0, 3
            []
          when 1
            ["select", "name"]
          when 2
            ["select"]
          end.concat(filter_opts)
        filter = filter&.to_sym
        key = key&.to_sym
        case filter
        when :select
          ->(job) { job[key] =~ /#{value}/ }
        when :reject
          ->(job) { job[key] !~ /#{value}/ }
        else
          ->(job) { true }
        end
      end

      def post_init
        unless options[:jobs].empty?
          after(0.1) { add_jobs(options[:jobs]) }
        end
      end

      def add_job(**job)
        jobs[job[:id]] = create_job(job) unless has_job?(job[:id])
      end

      def create_job(name:, **job)
        job[:runner] = self.class.registry_name
        job_class(name).new(job)
      end

      def job_class(name)
        get_constant("jobs/#{name}".to_s.camelize)
      end

      def run_job!(id)
        jobs[id].tap do |job|
          job.run
          info "#{job.summary} [#{job.tag}-rid##{job.run_id}]" unless job.summary.empty?
        end
      end

      def handle_exception(exception)
        error exception.full_message
      end
    end
  end
end
