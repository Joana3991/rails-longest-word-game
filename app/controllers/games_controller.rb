require 'open-uri'
require 'json'

class GamesController < ApplicationController

  def home
  end

  def new
    vowels = %w(A E I O U Y)
    @letters = Array.new(5) { vowels.sample }
    @letters += Array.new(5) { (('A'..'Z').to_a - vowels).sample }
    @letters.shuffle!
    # @letters = (1..10).map { rand(65..90).chr }
  end

  def score
    @word = params[:user_answer].upcase
    @grid = params[:letters].split
    @message =  case check_word
                when 1 then 'Sorry, but word can`t be built out of the grid'
                when 2 then 'Sorry but word does not seem to be a valid English word...'
                else
                  'Congratulations!!'
                end
  end

  private

  def in_grid?
    @word.chars.all? { |letter| @word.count(letter) <= @grid.count(letter) }
  end

  def english_word?
    response = URI.open("https://wagon-dictionary.herokuapp.com/#{@word}")
    hash = JSON.parse(response.read)
    hash['found']
  end

  def check_word
    if !in_grid?
      1
    elsif !english_word?
      2
    end
  end
end
