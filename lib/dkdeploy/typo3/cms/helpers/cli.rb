module Dkdeploy
  module Typo3
    module Cms
      module Helpers
        # TYPO3 cli helpers
        module Cli
          # Execute a task typo3/cli_dispatch.phpsh cli_params
          #
          # @param cli_params [Array] list of arguments for typo3/cli_dispatch.phpsh
          # @return [Boolean] returns true/false as success of execution
          def typo3_cli(*cli_params)
            path_to_cli_dispatch = File.join(current_path, fetch(:path_to_typo3_cli))
            run_script(current_path, path_to_cli_dispatch, cli_params)
          end

          # Execute a task typo3/cli_dispatch.phpsh cli_params in a specific directory
          #
          # @param path [String] file path where task is to be executed
          # @param cli_params [Array] list of arguments for typo3/cli_dispatch.phpsh
          # @return [Boolean] returns true/false as success of execution
          def typo3_cli_in_path(path, *cli_params)
            path_to_cli_dispatch = File.join(path, fetch(:path_to_typo3_cli))
            run_script(path, path_to_cli_dispatch, cli_params)
          end

          # Returns the last results of invocations of a task typo3/cli_dispatch.phpsh cli_params
          # Invocation can be controlled by the result of a given block.
          # True repeats the invocation until maximum_loop_count is reached.
          # False stops invocation regardless of loop count.
          #
          # @param maximum_loop_count [Integer] number of maximum attempts to run task
          # @param cli_params [Array] list of arguments for typo3/cli_dispatch.phpsh
          # @return [String] returns the last result of executing task
          def capture_typo3_cli_in_loop(maximum_loop_count, *cli_params, &block)
            path_to_cli_dispatch = File.join(current_path, fetch(:path_to_typo3_cli))
            capture_script_in_loop(current_path, path_to_cli_dispatch, maximum_loop_count, cli_params, &block)
          end

          # Returns the last results of invocations of a task typo3/cli_dispatch.phpsh cli_params
          # Invocation can be controlled by the result of a given block.
          # True repeats the invocation until maximum_loop_count is reached.
          # False stops invocation regardless of loop count.
          #
          # @param path [String] file path where task is to be executed
          # @param maximum_loop_count [Integer] number of maximum attempts to run task
          # @param cli_params [Array] list of arguments for typo3/cli_dispatch.phpsh
          # @return [String] returns the last result of executing task
          def capture_typo3_cli_in_path_in_loop(path, maximum_loop_count, *cli_params, &block)
            path_to_cli_dispatch = File.join(path, fetch(:path_to_typo3_cli))
            capture_script_in_loop(path, path_to_cli_dispatch, maximum_loop_count, cli_params, &block)
          end

          # Execute a typo3_console task with cli_params
          #
          # @param cli_params [Array] list of arguments for typo3/cli_dispatch.phpsh
          # @return [Boolean] returns true/false as success of execution
          def typo3_console(*cli_params)
            path_to_typo3_console = File.join(current_path, fetch(:path_to_typo3_console))
            run_script(current_path, path_to_typo3_console, cli_params)
          end

          # Execute a typo3_console task with cli_params in a specific directory
          #
          # @param path [String] file path where task is to be executed
          # @param cli_params [Array] list of arguments for typo3/cli_dispatch.phpsh
          # @return [Boolean] returns true/false as success of execution
          def typo3_console_in_path(path, *cli_params)
            path_to_typo3_console = File.join(path, fetch(:path_to_typo3_console))
            run_script(path, path_to_typo3_console, cli_params)
          end

          # Returns the last results of invocations of a a typo3_console task with cli_params
          # Invocation can be controlled by the result of a given block.
          # True repeats the invocation until maximum_loop_count is reached.
          # False stops invocation regardless of loop count.
          #
          # @param maximum_loop_count [Integer] number of maximum attempts to run task
          # @param cli_params [Array] list of arguments for typo3/cli_dispatch.phpsh
          # @return [String] returns the last result of executing task
          def capture_typo3_console_in_loop(maximum_loop_count, *cli_params, &block)
            path_to_typo3_console = File.join(current_path, fetch(:path_to_typo3_console))
            capture_script_in_loop(current_path, path_to_typo3_console, maximum_loop_count, cli_params, &block)
          end

          # Returns the last results of invocations of a typo3_console task with cli_params
          # Invocation can be controlled by the result of a given block.
          # True repeats the invocation until maximum_loop_count is reached.
          # False stops invocation regardless of loop count.
          #
          # @param path [String] file path where task is to be executed
          # @param maximum_loop_count [Integer] number of maximum attempts to run task
          # @param cli_params [Array] list of arguments for typo3/cli_dispatch.phpsh
          # @return [String] returns the last result of executing task
          def capture_typo3_console_in_path_in_loop(path, maximum_loop_count, *cli_params, &block)
            path_to_typo3_console = File.join(path, fetch(:path_to_typo3_console))
            capture_script_in_loop(path, path_to_typo3_console, maximum_loop_count, cli_params, &block)
          end

          # Execute a script with cli_params in a specific directory
          #
          # @param path [String] file path where task is to be executed
          # @param script [String] path to script
          # @param cli_params [Array] list of arguments for typo3/cli_dispatch.phpsh
          # @return [Boolean] returns true/false as success of execution
          def run_script(path, script, *cli_params)
            on primary :backend do |host|
              within path do
                unless test " [ -e #{script} ] "
                  error I18n.t('resource.not_exists_on_host', resource: script, host: host.hostname, scope: :dkdeploy)
                  next
                end

                with fetch(:typo3_environment_cli) do
                  execute :php, script, *cli_params
                end
              end
            end
          end

          # Returns the last results of invocations of a script
          # Invocation can be controlled by the result of a given block.
          # True repeats the invocation until maximum_loop_count is reached.
          # False stops invocation regardless of loop count.
          #
          # @param path [String] file path where task is to be executed
          # @param script [String] path to script
          # @param maximum_loop_count [Integer] number of maximum attempts to run task
          # @param cli_params [Array] list of arguments for the script
          # @return [String] returns the last result of executing task
          def capture_script_in_loop(path, script, maximum_loop_count, *cli_params)
            output = nil

            on primary :backend do |host|
              within path do
                unless test "[ -e #{script} ]"
                  error I18n.t('resource.not_exists_on_host', resource: script, host: host.hostname, scope: :dkdeploy)
                  next
                end

                loop_counter = 1

                while loop_counter <= maximum_loop_count
                  info I18n.t('tasks.cli.show_loop_counter', loop_counter: loop_counter, scope: :dkdeploy)
                  with fetch(:typo3_environment_cli) do
                    output = capture :php, script, *cli_params
                  end
                  if block_given?
                    unless yield(output, loop_counter, self)
                      info I18n.t('tasks.cli.block_yields_false', loop_counter: loop_counter, scope: :dkdeploy)
                      break
                    end
                  end
                  loop_counter += 1
                end
                info I18n.t('tasks.cli.maximum_calls_reached', scope: :dkdeploy) if loop_counter > maximum_loop_count
              end
            end

            output
          end
        end
      end
    end
  end
end
