module Parking
  class Lot < Base
    @@last_id = 0
    attr_reader :id, :slots, :free_slots

    def initialize(no_of_slots)
      self.free_slots = {}
      self.slots = build_slots(no_of_slots)
      self.id = self.class.last_id
    end

    def park_nearest_exit(registration_no, color)
      current_nearest_slot = nearest_exit_slot
      raise ParkingLot::SpaceNotAvailableError.new unless current_nearest_slot

      car = Car.new(registration_no, color)

      slots[current_nearest_slot].allot_vehicle(car)
      self.free_slots.delete(current_nearest_slot)

      [ slots[current_nearest_slot], car ]
    end

    def free(slot_no)
      raise ParkingLot::SlotNotFound.new unless slots[slot_no]

      freed_vehicle = slots[slot_no].free_vehicle
      self.free_slots[slot_no] = true

      [ slots[slot_no], freed_vehicle ]
    end

    def nearest_exit_slot
      self.free_slots.keys.min
    end

    def alloted_slots
      slots.select { |slot_id, _| !free_slots[slot_id] }
    end

    def has_a_free_slot?
      !self.free_slots.keys.empty?
    end

    private
    attr_writer :id, :slots, :free_slots
    def self.last_id
      @@last_id += 1
      @@last_id
    end

    def build_slots(no_of_slots)
      slot_map = {}
      no_of_slots.times do
        slot = Slot.new
        slot_map[slot.id] = slot
        self.free_slots[slot.id] = true
      end
      slot_map
    end
  end
end
