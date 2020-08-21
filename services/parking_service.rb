class ParkingService
  def initialize
    @parking_lots = []
    @indexes = {}
  end

  def create_parking_lot(no_of_slots)
    parking_lot = Parking::Lot.new(no_of_slots)
    @parking_lots.push(parking_lot)
    @indexes[parking_lot.id] = IndexingService.new

    { no_of_slots: no_of_slots, parking_lot_id: parking_lot.id }
  end

  def park(registration_no, color)
    parking_lot = nearest_parking_lot
    slot, car = parking_lot.park_nearest_exit(registration_no, color)

    @indexes[parking_lot.id].add_val_to_color_index(:cars, color, car.registration_no)
    @indexes[parking_lot.id].add_val_to_color_index(:slots, color, slot.id)
    @indexes[parking_lot.id].add_slot_by_registration_index(slot.id, registration_no)

    { slot_no: slot.id, success: true, slot: slot }
  rescue ParkingLot::SpaceNotAvailableError => e
    { slot_no: nil, success: false, error: :parking_lot_full }
  rescue ParkingLot::NotFound
    { slot_no: nil, success: false, error: :parking_lot_found }
  end

  def leave(parking_lot_id, slot_no)
    parking_lot = find_parking_lot(parking_lot_id)
    slot, car = parking_lot.free(slot_no)

    @indexes[parking_lot.id].del_val_from_color_index(:cars, car.color, car.registration_no)
    @indexes[parking_lot.id].del_val_from_color_index(:slots, car.color, slot_no)
    @indexes[parking_lot.id].del_slot_by_registration_index(car.registration_no)

    { slot_no: slot.id }
  rescue ParkingLot::SlotNotFound => e
    { slot_no: nil, success: false, error: :slot_not_found }
  end

  def status
    result = { parking_lots: {} }

    @parking_lots.each do |parking_lot|
      result[:parking_lots][parking_lot.id] = { parked_cars: [] }
      parking_lot.alloted_slots.map do |_, alloted_slot|
        result[:parking_lots][parking_lot.id][:parked_cars].push(
            {
                slot_no: alloted_slot.id,
                registration_no: alloted_slot.vehicle.registration_no,
                color: alloted_slot.vehicle.color
            }
        )
      end
    end

    result
  end

  def registration_numbers_for_cars_with_colour(color)
    registration_nos = []
    @parking_lots.each do |parking_lot|
      registration_nos += @indexes[parking_lot.id].get_val_by_color(:cars, color)
    end

    if registration_nos.empty?
      { error: :not_found, success: false }
    else
      { registration_nos: registration_nos, success: true }
    end
  end

  def slot_numbers_for_cars_with_colour(color)
    slot_nos = []
    @parking_lots.each do |parking_lot|
      slot_nos += @indexes[parking_lot.id].get_val_by_color(:slots, color)
    end

    if slot_nos.empty?
      { error: :not_found, success: false }
    else
      { slot_nos: slot_nos, success: true }
    end
  end

  def slot_number_for_registration_number(registration_no)
    slot_no = nil
    @parking_lots.each do |parking_lot|
      slot_no = @indexes[parking_lot.id].get_slot_by_registration(registration_no)

      if slot_no
        break
      end
    end

    if slot_no
      { slot_no: slot_no, success: true }
    else
      { error: :not_found, success: false }
    end
  end

  def nearest_parking_lot
    parking_lot = @parking_lots.find do |parking_lot|
      parking_lot.has_a_free_slot?
    end
    raise ParkingLot::SpaceNotAvailableError if parking_lot.nil?
    parking_lot
  end

  def find_parking_lot(id)
    parking_lot = @parking_lots.find do |parking_lot|
      parking_lot.id == id
    end
    raise ParkingLot::NotFound if parking_lot.nil?

    parking_lot
  end

end
