require "minimist/version"
require "minimist/errors"

module Minimist
  class << self
    REGEX  = {
      command: /^[A-Za-z]/,
      double_dash_negation: /^--no-.+/,
      double_dash: /^--.+/,
      single_dash: /^-[^-]+/
    }

    #
    # Accepts an array and returns a hash
    # with actions and options passed
    #
    def parse(argv)
      @argv = argv

      out = {
        commands: [],
        options: {}
      }
      skip = false
      type = nil

      argv.each_with_index do |arg, i|
        # reset
        type = nil

        if skip
          skip = false
          next
        end

        REGEX.each do |name, regex|
          match = arg =~ regex

          if match
            type = name
            break
          end
        end

        #
        # arg type method should indicate whether it wants
        # to skip the next value or not
        #
        out, skip = send(type, arg, i, out)
      end

      out
    end

    private

    def command(arg, _, argv_object)
      argv_object[:commands] << arg
      [argv_object, false]
    end

    #
    # If the next command is
    #
    def single_dash(arg, index, argv_object)
      should_skip = false

      #
      # match -abc, -n5 arg types
      #
      if match_data = arg.match(/^-([A-Za-z])([0-9])$/)
        argv_object[:options][match_data[1].to_sym] = match_data[2]
      elsif @argv[index + 1] =~ /^(\d|[A-Za-z])/
        argv_object[:options][arg.slice(1..-1).to_sym] = transform(@argv[index + 1])
        should_skip = true
      else
        #
        # loop through and apply each letter to the
        # options object
        #
        arg.slice(1..-1).split('').each do |letter|
          argv_object[:options][letter.to_sym] = true
        end
      end

      [argv_object, should_skip]
    end

    def double_dash(arg, index, argv_object)
      match_data = arg.match(/^--([A-Za-z]*-?[A-Za-z]*)=?([A-Za-z0-9]*)/)
      val = true
      should_skip = false

      if !match_data[2].empty?
        argv_object[:options][match_data[1].to_sym] = match_data[2]
      else
        val = true

        if @argv[index + 1] =~ REGEX[:command]
          val = @argv[index + 1]
          should_skip = true
        end

        argv_object[:options][transform(match_data[1].to_sym)] = val
      end

      [argv_object, should_skip]
    end

    def double_dash_negation(arg, index, argv_object)
      #
      # regex matvch --no-val into val = true
      #
      match_data = arg.match(/^--no-([A-Za-z]*-?[A-Za-z]*)/)
      argv_object[:options][match_data[1].to_sym] = false

      [argv_object, false]
    end

    def transform(val)
      val.to_s.gsub('-', '_').to_sym
    end
  end
end
