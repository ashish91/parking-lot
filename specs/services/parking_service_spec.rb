require File.join(Dir.pwd, 'specs/spec_helper')

describe "ParkingService" do
  before :each do
    @parking_service = ParkingService.new
    @parking_lots_result = @parking_service.create_parking_lot(2)
  end

  it "creates parking lot" do
    expect(@parking_service.create_parking_lot(10)).to eq({ no_of_slots: 10, parking_lot_id: 2 })
  end

  it "Parks a car" do
    result = @parking_service.park('HHHH-TTTT-TTTT', :red)

    expect(result[:success]).to be_truthy
    expect(result[:slot].vehicle.registration_no).to eq('HHHH-TTTT-TTTT')
    expect(result[:slot].vehicle.color).to eq(:red)
  end

  it "leaves a car" do
    result = @parking_service.park('TTTT-TTTT-TTTT', :blue)
    expect(@parking_service.leave(@parking_lots_result[:parking_lot_id], result[:slot_no])[:slot_no]).to eq(result[:slot_no])
  end

  it "parking lot full" do
    2.times do
      @parking_service.park('TTTT-TTTT-TTTT', :blue)
    end
    expect(@parking_service.park('TTTT-TTTT-HHHH', :green)).to eq({ slot_no: nil, success: false, error: :parking_lot_full })
  end

  it "can't find slot" do
    @parking_service.park('TTTT-TTTT-TTTT', :blue)
    expect(@parking_service.leave(@parking_lots_result[:parking_lot_id],-1)).to eq({ slot_no: nil, success: false, error: :slot_not_found })
  end

  it "checks status" do
    2.times do
      @parking_service.park('TTTT-TTTT-TTTT', :blue)
    end

    expect(@parking_service.status[:parking_lots][1][:parked_cars].map{ |car| car[:color] }).to eq([:blue, :blue])
    expect(@parking_service.status[:parking_lots][1][:parked_cars].map{ |car| car[:registration_no] }).to eq(['TTTT-TTTT-TTTT', 'TTTT-TTTT-TTTT'])
  end

  it "checks registration_numbers_for_cars_with_colour" do
    2.times do
      @parking_service.park('TTTT-TTTT-TTTT', :blue)
    end

    expect(@parking_service.registration_numbers_for_cars_with_colour(:blue) ).to eq({:registration_nos=>["TTTT-TTTT-TTTT"], :success=>true})
  end

  it "can't find registration_numbers_for_cars_with_colour" do
    2.times do
      @parking_service.park('TTTT-TTTT-TTTT', :blue)
    end

    expect(@parking_service.registration_numbers_for_cars_with_colour(:green) ).to eq({:error=>:not_found, :success=>false})
  end

  it "checks slot_numbers_for_cars_with_colour" do
    slots = []
    2.times do
      slots << @parking_service.park('TTTT-TTTT-TTTT', :blue)[:slot_no]
    end

    expect(@parking_service.slot_numbers_for_cars_with_colour(:blue)[:slot_nos].sort ).to eq(slots.sort)
  end

  it "can't find slot_numbers_for_cars_with_colour" do
    2.times do
      @parking_service.park('TTTT-TTTT-TTTT', :blue)
    end

    expect(@parking_service.slot_numbers_for_cars_with_colour(:green) ).to eq({:error=>:not_found, :success=>false})
  end

  it "checks slot_number_for_registration_number" do
    slot_no = @parking_service.park('TTTT-TTTT-TTTT', :blue)[:slot_no]

    expect(@parking_service.slot_number_for_registration_number('TTTT-TTTT-TTTT')[:slot_no] ).to eq(slot_no)
  end


  it "can't find slot_number_for_registration_number" do
    @parking_service.park('TTTT-TTTT-TTTT', :blue)[:slot_no]

    expect(@parking_service.slot_number_for_registration_number(:green) ).to eq({:error=>:not_found, :success=>false})
  end
end
