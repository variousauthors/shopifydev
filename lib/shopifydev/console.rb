require 'shopifydev/pry/commands'
require 'shopifydev/shopify_api/caches'

require 'term/ansicolor'
class Color
  if Pry.config.color
    extend Term::ANSIColor
  else
    class << self
      def method_missing
        ''
      end
    end
  end
end

Pry.config.hooks.add_hook(:before_session, :set_context) { |_, _, pry| pry.input = StringIO.new("cd ShopifyAPI") }