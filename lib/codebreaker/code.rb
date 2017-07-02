class Code
  def initialize
    @code = create_code
  end

  def to_s
    "#{@code}"
  end

  def compare_with(guess)
    return '++++' if exact_match(guess)
    '+' * pluses(guess) + '-' * minuses(guess)
  end

  private

  def exact_match(guess)
    @code == guess
  end

  def create_code
    (Array.new(4) { rand(1..6) }).join.to_s
  end

  def pluses(guess)
    zipped(guess)
      .select { |el| el[0] == el[1] }
      .count
  end

  def minuses(guess)
    return 0 if exact_match(guess)
    arr = delete_pairs(guess)
    arr[1].each do |number|
      next unless arr[0].include?(number)
      arr[0].delete_at(arr[0].index(number))
    end
    arr[1].size - arr[0].size
  end

  def zipped(guess)
    @code.split(//).zip(guess.split(//))
  end

  def delete_pairs(guess)
    zipped(guess)
      .delete_if { |el| el[0] == el[1] }
      .transpose
  end
end
