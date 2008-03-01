Infinity = 1.0 / 0.0

module GitHub
  class Command
    def self.call(*args)
      validate_arity_for(args)
      new.run(*args)
    end

    def self.arity
      instance_method(:run).arity
    end

    def self.valid_args
      if arity < 0
        (-arity - 1)..Infinity
      else
        [arity]
      end
    end

    def self.validate_arity_for(args)
      unless valid_args.include?(args.size)
        raise ArgumentError, ("wrong number of arguments (%d for %s)" % [args.size, arity])
      end
    end

    def helper
      @helper ||= Helper.new
    end
  end
end
