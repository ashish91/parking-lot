require File.join(Dir.pwd, 'specs/spec_helper')

describe "CommandParserService" do
  it "accepts command without args" do
    command, args = CommandParserService.parse_line("test_command")
    expect(command).to eq("test_command")
    expect(args).to be_empty
  end

  it "accepts command with one arg" do
    command, args = CommandParserService.parse_line("test_command arg")
    expect(command).to eq("test_command")
    expect(args).to eq(['arg'])
  end

  it "accepts command with multiple args" do
    command, args = CommandParserService.parse_line("test_command arg1 arg2 arg3")

    expect(command).to eq("test_command")
    expect(args).to eq(['arg1', 'arg2', 'arg3'])
  end
end
