# frozen_string_literal: true

require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = ('a'..'z').to_a.sample(10)
  end

  def score
    @word = params[:word]
    @letters = params[:letters].split
    @message = ''

    # The word can’t be built out of the original grid
    if !@word.each_char.all? { |c| @letters.include?(c) }
      @message = "Sorry, but #{@word} can't be built out of #{@letters.join(', ')}"
    elsif url = "https://wagon-dictionary.herokuapp.com/#{@word}"
      # The word is valid according to the grid, but is not a valid English word
      file = JSON.parse(open(url).read)
      # word is false according to dictionary
      @message = if file['found'] == false
                   "Sorry, but #{@word} does not seen to be a valid English word.."
                 else
                   # The word is valid according to the grid and is an English word
                   "Congratulation! #{@word} is a valid English word!"
                 end
    end
  end
end
