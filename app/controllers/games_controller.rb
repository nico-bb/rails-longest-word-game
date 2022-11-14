class GamesController < ApplicationController
  def new
    letters = ("a".."z").to_a
    @@grid = []
    10.times do
      @@grid.push(letters.sample)
    end
    @grid = @@grid
    @@start_time = Time.now
  end

  def score
    @@end_time = Time.now
    url = "https://wagon-dictionary.herokuapp.com/"
    @response = {
      valid: valid_word?(params[:guess]),
      score: 0,
      message: "Your word is not in the grid",
      time: (@@end_time - @@start_time)
    }
    if @response[:valid]
      guess_serialized = URI.open("#{URL}#{attempt}").read
      @response = compute_response(@response, guess_serialized)
    end

    p @response
    render("score")
  end

  private

  def valid_word?(guess)
    working_list = @@grid.map do |char|
      char
    end
    guess.upcase.chars.each do |char|
      char_index = working_list.index(char)
      return false if char_index.nil?
  
      working_list.delete_at(char_index)
    end
  
    return true
  end

  def compute_response(response, url)
    guess_result = JSON.parse(url)
    if guess_result["found"]
      response[:score] = (guess_result["length"] * 2) - response[:time].to_i
      response[:message] = "Well Done!"
    else
      response[:message] = "Well Done! not an english word"
    end
    return response
  end
end
