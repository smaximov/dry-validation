require 'dry/validation/messages/abstract'

module Dry
  module Validation
    module Messages
      class NoOp < Abstract
        class Message
          def initialize(message)
            @message = message
          end

          def %(other)
            @message.merge(variables: other)
          end
        end

        def rule(name, _options = {})
          name
        end

        def lookup(predicate, options = {})
          # skip when #call in invoked as messages[rule]
          # in MessageCompiler#visit_predicate:
          return nil if options.empty?

          tokens = options.merge(
            arg_type: config.arg_types[options[:arg_type]],
            val_type: config.val_types[options[:val_type]],
            message_type: options[:message_type] || :failure
          )

          [predicate, tokens]
        end

        def get(key, options = {})
          Message.new(predicate: key, options: options)
        end
      end
    end
  end
end
