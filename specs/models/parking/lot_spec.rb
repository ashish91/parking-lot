require File.join(Dir.pwd, 'specs/spec_helper')

describe "Parking::Lot" do

  it "Creates a parking lot" do
    parking_lot = Parking::Lot.new(4)
    expect(parking_lot.slots.count).to eq(4)
    expect(parking_lot.free_slots.keys).to eq((1..4).to_a)
  end

  it "Parks car to nearest exit" do
    parking_lot = Parking::Lot.new(5)

    parked_slot, _car = parking_lot.park_nearest_exit(123, :blue)
    expect(parking_lot.alloted_slots.first.first).to eq(parked_slot.id)
    expect(parking_lot.free_slots.count).to eq(4)
  end

  it "Doesn't park car if parking lot full" do
    parking_lot = Parking::Lot.new(1)

    parked_slot, _car = parking_lot.park_nearest_exit(123, :blue)
    expect(parking_lot.alloted_slots.first.first).to eq(parked_slot.id)
    expect(parking_lot.free_slots.count).to eq(0)

    expect{
      parking_lot.park_nearest_exit(234, :red)
    }.to raise_error(ParkingLot::SpaceNotAvailableError)
    expect(parking_lot.free_slots.count).to eq(0)
  end

  it "Frees car when car leaves" do
    parking_lot = Parking::Lot.new(20)

    parked_slot, _car = parking_lot.park_nearest_exit(123, :blue)
    expect(parking_lot.alloted_slots.first.first).to eq(parked_slot.id)
    expect(parking_lot.free_slots.count).to eq(19)

    parking_lot.free(parked_slot.id)
    expect(parking_lot.alloted_slots).to be_empty
    expect(parking_lot.free_slots.count).to eq(20)
  end
end
