class Vehicle < Base
  @@last_id = 0

  attr_reader :id, :color, :registration_no

  def initialize(registration_no, color)
    self.color = color
    self.registration_no = registration_no
    self.id = self.class.last_id
  end

  private
  attr_writer :id, :color, :registration_no
  def self.last_id
    @@last_id += 1
    @@last_id - 1
  end
end
