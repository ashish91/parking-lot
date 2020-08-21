require File.join(Dir.pwd, 'specs/spec_helper')

describe "Parking::Slot" do
  it "Slots have free state when created" do
    slot = Parking::Slot.new
    expect(slot.state).to eq(:free)
  end

  it "Changes state to parked once vehicle is parked" do
    slot = Parking::Slot.new
    car = Car.new(123, :blue)

    slot.allot_vehicle(car)
    expect(slot.state).to eq(:parked)
    expect(slot.vehicle.id).to eq(car.id)
  end

  it "Changes state to free once vehicle leaves" do
    slot = Parking::Slot.new
    car = Car.new(123, :blue)

    slot.allot_vehicle(car)
    slot.free_vehicle

    expect(slot.state).to eq(:free)
    expect(slot.vehicle).to be_nil
  end
end
