class MarkovChatterbot
  # NONWORD = "\n"
  BLANK = '\n'
  MAXGEN = 1000
  
  attr_reader :state
  
  def initialize order = 4
    @order = order
    @state = Hash.new { |h, k| h[k] = [] }
  end
  
  def input text
    context = [BLANK] * @order
    text.downcase.chars.each do |ch|
      learn context, ch
      context.push(ch).shift
    end
    learn context, BLANK
  end
  
  # def input text
  #   word1 = word2 = NONWORD
  #   text.split(/\s+/).reject(&:empty?).each do |word3|
  #     learn word1, word2, word3
  #     word1, word2 = word2, word3
  #   end
  #   learn word1, word2, NONWORD
  # end
  
  def output
    output = []
    context = [BLANK] * @order
    (0..MAXGEN).each do
      ch = lookup context
      break if ch == BLANK
      output << ch
      context.push(ch).shift
    end
    output.join.sub(/^./) { $&.upcase! }
  end
  
  # def output
  #   output = []
  #   word1 = word2 = NONWORD
  #   (0..MAXGEN).each do |i|
  #     word3 = lookup word1, word2
  #     break if word3 == NONWORD
  #     output << word3
  #     word1, word2 = word2, word3
  #   end
  #   output.join ' '
  # end
  
  private
  
  def key context
    context.join
  end
  
  # def key a, b
  #   a = a.downcase.gsub /[^a-z0-9]+/, ''
  #   b = b.downcase.gsub /[^a-z0-9]+/, ''
  #   "#{a} #{b}"
  # end
  
  def lookup context
    @state[key context].sample
  end
  
  # def lookup a, b
  #   @state[key(a, b)].sample
  # end
  
  def learn context, ch
    chars = @state[key context]
    chars << ch #unless chars.include? ch
  end
  
  # def learn a, b, c
  #   words = @state[key(a, b)]
  #   words << c #unless words.include? c
  # end
  
end
