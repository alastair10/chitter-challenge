class InputDefence
  def valid?(input)
    input.match(/<.+>/) ? false : true
  end
end