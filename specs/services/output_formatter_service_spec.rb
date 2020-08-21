require File.join(Dir.pwd, 'specs/spec_helper')

describe "OutputFormatterService" do
  it "Outputs create_parking_lot" do
    expect(STDOUT).to receive(:puts).with("Created a parking lot with 2 slots")
    expect(STDOUT).to receive(:puts).with("Parking Lot ID is 1")
    OutputFormatterService.create_parking_lot({ no_of_slots: 2, parking_lot_id: 1 })
  end

  it "Outputs park when parking available" do
    expect(STDOUT).to receive(:puts).with("Allocated slot number: 2")
    OutputFormatterService.park({ success: true, slot_no: 2 })
  end

  it "Outputs park when parking full" do
    expect(STDOUT).to receive(:puts).with("Sorry, parking lot is full")
    OutputFormatterService.park({ error: :parking_lot_full })
  end

  it "Outputs leave" do
    expect(STDOUT).to receive(:puts).with("leave 2")
    OutputFormatterService.leave({ slot_no: 2 })
  end

  it "Outputs registration_numbers_for_cars_with_colour" do
    expect(STDOUT).to receive(:puts).with("KA-01-BB-0001, KA-01-BB-0002")
    OutputFormatterService.registration_numbers_for_cars_with_colour({ success: true, registration_nos: ['KA-01-BB-0001', 'KA-01-BB-0002'] })
  end

  it "Outputs slot_numbers_for_cars_with_colour" do
    expect(STDOUT).to receive(:puts).with("2, 4, 6")
    OutputFormatterService.slot_numbers_for_cars_with_colour({ success: true, slot_nos: ['2', '4', '6'] })
  end

  it "Outputs slot_number_for_registration_number" do
    expect(STDOUT).to receive(:puts).with("2")
    OutputFormatterService.slot_number_for_registration_number({ success: true, slot_no: '2' })
  end
end
