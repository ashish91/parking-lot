class OutputFormatterService
  class << self
    def create_parking_lot(result)
      puts "Created a parking lot with #{result[:no_of_slots]} slots"
      puts "Parking Lot ID is #{result[:parking_lot_id]}"
    end

    def park(result)
      if result[:success]
        puts "Allocated slot number: #{result[:slot_no]}"
      elsif result[:error] == :parking_lot_full
        puts "Sorry, parking lot is full"
      end
    end

    def leave(result)
      puts "leave #{result[:slot_no]}"
    end

    def status(result)
      puts "Slot no. Registration No Colour"
      result[:parking_lots].each do |parking_lot_id, parking_cars_result|
        puts "#Parking ID #{parking_lot_id}"
        parking_cars_result[:parked_cars].each do |parked_car|
          puts "#{parked_car[:slot_no]} #{parked_car[:color]} #{parked_car[:registration_no]}"
        end
      end
    end

    def registration_numbers_for_cars_with_colour(result)
      if result[:success]
        puts result[:registration_nos].join(', ')
      elsif result[:error] == :not_found
        not_found
      end
    end

    def slot_numbers_for_cars_with_colour(result)
      if result[:success]
        puts result[:slot_nos].join(', ')
      elsif result[:error] == :not_found
        not_found
      end
    end

    def slot_number_for_registration_number(result)
      if result[:success]
        puts result[:slot_no]
      elsif result[:error] == :not_found
        not_found
      end
    end

    def not_found
      puts "Not Found"
    end
  end
end
