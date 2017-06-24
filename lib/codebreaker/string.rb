class String
  def like regex
    !self[regex].nil?
  end
end