# frozen_string_literal: true

module Dkdeploy
  module Typo3
    # TYPO3 dsl api
    module DSL
      # Execute a rake/capistrano task only for given server
      #
      # @param server [Capistrano::Configuration::Server] Server to execute task
      # @param task [String] Name of rake/capistrano task
      # @param args [Array] Arguments of rake/capistrano task
      def invoke_for_server(server, task, *args)
        backup_filter = fetch :filter, {}
        begin
          new_server_filter = Marshal.load(Marshal.dump(backup_filter))
          new_server_filter[:host] = server.hostname
          set :filter, new_server_filter
          env.setup_filters
          info I18n.t('dsl.invoke_for_server.set_filter', task: task, host: server.hostname, scope: :dkdeploy)
          invoke task, *args
          Rake::Task[task].reenable
        ensure
          set :filter, backup_filter
          env.setup_filters
        end
      end
    end
  end
end
