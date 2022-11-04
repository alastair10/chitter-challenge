require 'input_defence'

describe InputDefence do
  let(:check) {InputDefence.new}

  it "returns true when the input contains normal text" do
    expect(check.valid?('script')).to eq(true)
  end

  it "returns false when the input contains HTML tags" do
    expect(check.valid?('<script>')).to eq(false)
  end

  it "returns false when the input contains linked tag" do
    expect(check.valid?('<a href="/peeps">')).to eq(false)
  end
end