require File.join(Dir.pwd, 'specs/spec_helper')

describe "CommandValidatorService" do
  before :each do
    CommandValidatorService.parking_lot_created = true
  end

  it "doesn't allow other commands if parking lot not created" do
    CommandValidatorService.parking_lot_created = false
    expect{ CommandValidatorService.validate(:status, []) }.to raise_error(Command::Invalid, 'Parking lot not created.')
  end

  it "doesn't allow commands not allowed" do
    expect{ CommandValidatorService.validate(:random_command, []) }.to raise_error(Command::Invalid, 'random_command is not a recognized command.')
  end

  it "validates number of args for a command" do
    expect{ CommandValidatorService.validate(:park, []) }.to raise_error(
                                                                 Command::Invalid, 'Command park expects 2 arguments but received 0.'
                                                             )
  end

  it "validates args pattern for a command" do
    expect{ CommandValidatorService.validate(:leave, [1, 'one']) }.to raise_error(
                                                                 Command::Invalid, 'Invalid argument one in command leave.'
                                                             )
  end
end
