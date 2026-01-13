# Fix for Psych aliases in Ruby 3.3.6
# Enable YAML aliases for database configuration

if defined?(Psych) && Psych::VERSION.to_f >= 4.0
  module Psych
    class << self
      alias_method :original_load_file, :load_file

      def load_file(filename, **kwargs)
        kwargs[:aliases] = true unless kwargs.key?(:aliases)
        original_load_file(filename, **kwargs)
      end

      alias_method :original_safe_load_file, :safe_load_file if respond_to?(:safe_load_file)

      def safe_load_file(filename, **kwargs)
        kwargs[:aliases] = true unless kwargs.key?(:aliases)
        original_safe_load_file(filename, **kwargs)
      end if respond_to?(:safe_load_file)
    end
  end
end
