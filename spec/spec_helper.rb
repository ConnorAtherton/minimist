$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'minimist'

def parse(string)
  Minimist.parse(string.split(" "))
end
