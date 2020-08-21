require File.join(Dir.pwd, 'specs/spec_helper')

describe "Car" do
  it "Creates a car with registration no and color" do
    car = Car.new(123, :blue)

    expect(car.registration_no).to eq(123)
    expect(car.color).to eq(:blue)
  end
end
