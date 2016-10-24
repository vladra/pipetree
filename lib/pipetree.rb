class Pipetree < Array
  VERSION = "0.0.1"

  # Allows to implement a pipeline of filters where a value gets passed in and the result gets
  # passed to the next callable object.
  Stop = Class.new

  # options is mutuable.
  # we have a fixed set of arguments here, since array splat significantly slows this down, as in
  # call(input, *options)
  def call(input, options)
    inject(input) do |memo, block|
      res = evaluate(block, memo, options)
      return(Stop) if Stop == res
      res
    end
  end

  # TODO: implement for nested
  # TODO: remove in Representable::Debug.
  def inspect(separator="\n")
    string = each_with_index.collect do |func, i|
      name = File.readlines(func.source_location[0])[func.source_location[1]-1].match(/^\s+(\w+)/)[1]

      index = sprintf("%2d", i)
      "#{index}) #{name}"
      # name  = sprintf("%-60.300s", name) # no idea what i'm doing here.
      # "#{index}) #{name} #{func.source_location.join(":")}"
    end.join(separator)

    return string if separator == "," #FIXME
    "\n#{string}"
  end

private
  def evaluate(block, input, options)
    block.call(input, options)
  end


  module Macros # TODO: explicit test.
    # Macro to quickly modify an array of functions via Pipeline::Insert and return a
    # Pipeline instance.
    def insert!(new_function, options)
      Pipetree::Insert.(self, new_function, options)
    end
  end
  require "pipetree/insert"
  include Macros

  # Collect applies a pipeline to each element of input.
  class Collect < self
    # when stop, the element is skipped. (should that be Skip then?)
    def call(input, options)
      arr = []
      input.each_with_index do |item_fragment, i|
        result = super(item_fragment, options.merge(index: i)) # DISCUSS: NO :fragment set.
        Stop == result ? next : arr << result
      end
      arr
    end

    # DISCUSS: will this make it into the final version?
    class Hash < self
      def call(input, options)
        {}.tap do |hsh|
          input.each { |key, item_fragment|
            hsh[key] = super(item_fragment, options) }# DISCUSS: NO :fragment set.
        end
      end
    end
  end
end
