class CommandValidatorService
  @@parking_lot_created = false
  COMMAND_CONFIG = {
      create_parking_lot: {
          args_count: 1,
          args_pattern: [/\d+/]
      },
      park: {
          args_count: 2,
          args_pattern: [/^([a-zA-Z0-9]+\-)+[a-zA-Z0-9]+$/, /[a-zA-Z]+/]
      },
      leave: {
          args_count: 2,
          args_pattern: [/\d+/, /\d+/]
      },
      status: {
          args_count: 0,
          args_pattern: []
      },
      registration_numbers_for_cars_with_colour: {
          args_count: 1,
          args_pattern: [/[a-zA-Z]+/]
      },
      slot_numbers_for_cars_with_colour: {
          args_count: 1,
          args_pattern: [/[a-zA-Z]+/]
      },
      slot_number_for_registration_number: {
          args_count: 1,
          args_pattern: [/^([a-zA-Z0-9]+\-)+[a-zA-Z0-9]+$/]
      }
  }.freeze

  class << self
    def parking_lot_created
      @@parking_lot_created
    end

    def parking_lot_created=(val)
      @@parking_lot_created = val
    end

    def validate(command, args)
      @@errors = []
      command = command.to_sym

      validate_allowed_command(command)
      validate_parking_lot_persistence(command, args)

      validate_args_count(command, args)
      validate_args_pattern(command, args)

      if @@errors.length > 0
        raise Command::Invalid.new(@@errors.join(', '))
      end
    end

    def validate_allowed_command(command)
      unless COMMAND_CONFIG.keys.include?(command)
        raise Command::Invalid.new("#{command} is not a recognized command.")
      end
    end

    def validate_parking_lot_persistence(command, args)
if !@@parking_lot_created && command != :create_parking_lot
        @@errors.push('Parking lot not created.')
      elsif !@@parking_lot_created && command == :create_parking_lot
        @@parking_lot_created = true
      end
    end

    def validate_args_count(command, args)
      if COMMAND_CONFIG[command][:args_count] != args.count
        @@errors.push("Command #{command} expects #{COMMAND_CONFIG[command][:args_count]} arguments but received #{args.count}.")
      end
    end

    def validate_args_pattern(command, args)
      args.each_with_index do |arg, index|
        unless arg && COMMAND_CONFIG[command][:args_pattern][index].match(arg.to_s)
          @@errors.push("Invalid argument #{arg} in command #{command}.")
        end
      end

    end
  end
end
