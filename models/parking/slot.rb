module Parking
  class Slot < Base
    @@last_id = 0

    attr_reader :state, :vehicle, :id
    ALLOWED_STATES = [:free, :alloted].freeze

    def initialize
      self.state = :free
      self.id = self.class.last_id
      super
    end

    def allot_vehicle(vehicle)
      self.vehicle = vehicle
      self.alloted!
    end

    def free_vehicle
      freed_vehicle = self.vehicle

      self.vehicle = nil
      self.free!

      freed_vehicle
    end

    private
    attr_writer :state, :vehicle, :id

    def self.last_id
      @@last_id += 1
      @@last_id
    end

    def alloted!
      self.state = :parked
    end

    def free!
      self.state = :free
    end
  end
end
