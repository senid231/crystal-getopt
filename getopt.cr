# inspired by getopt.getopt in Python
# very useful method for command line tools

module GetOpt
  extend self

  class GetOptException < Exception
  end

  class InvalidOption < GetOptException
    def initialize(option : String?)
      super("Invalid option: #{option}")
    end
  end


  def getopt(args : Array(String), shortopts : String, longopts=Array(String).new : Array(String)|String) : {Array(Hash(String, String)), Array(String)}
    opts = Array(Hash(String, String)).new
    longopts = [longopts] if longopts.is_a? String

    while !args.empty? && args[0][0] == '-' && args[0].size > 1
      if args[0] == "--"
	args = args[1, args.size]
	break
      elsif args[0][0, 2] == "--"
	opts, args = get_longopts(opts, args, longopts)
      else
	opts, args = get_shortopts(opts, args, shortopts)
      end
    end

    return opts, args
  end


  def getopt(args : String, shortopts : String, longopts=Array(String).new : Array(String)|String) : {Array(Hash(String, String)), Array(String)}
    return getopt(args.split(" "), shortopts, longopts)
  end


  private def get_longopts(opts : Array(Hash(String, String)), args : Array(String), longopts : Array(String)) : {Array(Hash(String, String)), Array(String)}
    arg_val = args[0][2, args[0].size].split("=")
    if arg_val.size == 1
      raise InvalidOption.new(arg_val[0]) unless longopts.includes?(arg_val[0])
      opts << {arg_val[0] => ""}
    else
      raise InvalidOption.new(arg_val[0] + "=") unless longopts.includes?(arg_val[0] + "=")
      opts << {arg_val[0] => arg_val[1, arg_val.size].join}
    end

    return opts, args[1, args.size - 1]
  end


  private def get_shortopts(opts : Array(Hash(String, String)), args : Array(String), shortopts : String) : {Array(Hash(String, String)), Array(String)}
  arg = args[0][1, args[0].size]
    if arg.size > 1
      arg.to_s.each_char_with_index do |arg_char, i|
	raise InvalidOption.new(arg_char.to_s) unless shortopts.includes?(arg_char) && !shortopts.includes?(arg_char.to_s + ":")
      end
      args = args[1, args.size]
    else
      if args.size == 1 || args[1][0] == '-'
	raise InvalidOption.new(arg) unless shortopts.includes?(arg) && !shortopts.includes?(arg + ":")
	opts << {arg => ""}
	args = args[1, args.size]
      else
	raise InvalidOption.new(arg + "=") unless shortopts.includes?(arg + ":")
	opts << {arg => args[1]}
	args = args[2, args.size]
      end
    end
    return opts, args
  end


end # GetOpt
