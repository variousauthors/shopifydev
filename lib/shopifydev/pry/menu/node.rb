
module Shopifydev
  module Pry
    module Menu
      class Node
        attr_accessor :data, :index
      end

      class HeaderNode < Node

        def initialize(data)
          @data = data
          @index = nil
        end

        def draw
          Color.blue { data }
        end

        def index
          return nil
        end
      end

      class ChoiceNode < Node

        def initialize(data, index)
          @index = index
          @data = data
        end

        def draw
          Color.yellow{ self.index.to_s } + '. ' + data.to_s
        end

      end
    end
  end
end

