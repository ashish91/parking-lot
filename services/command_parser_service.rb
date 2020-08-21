class CommandParserService
  def self.parse_line(line)
    line = line.split(' ')

    command = line.shift
    args = line

    if ['create_parking_lot', 'leave'].include?(command)
      args[0] = args[0].to_i
    end

    [ command, args ]
  end
end
