# frozen_string_literal: true

require 'cli/ui'

class Hangman
  def loader
    puts 'Loading...'
  end

  def new_game
    word = generate_word
    @word_array = word.chars
    @guess_array = Array.new(@word_array.length) { '_' }
    puts "#{word} #{@word_array.length} #{@guess_array}"
  end

  def saver; end

  def generate_word
    word = ''
    loop do
      word = File.new('word_list.txt').readlines[Random.new.rand(0..10_000)].to_s.chomp
      next unless word.length.between?(5, 12)

      break
    end
    word
  end

  def play_round
    loop do
      CLI::UI::Prompt.ask('Play or Save?') do |handler|
        handler.option('Play') { guess }
        handler.option('Save') { saver }
      end
      exit if victory_check
    end
  end

  def guess
    puts @guess_array.join(' ')
    loop do
      @guess_attempt = CLI::UI.ask('Guess a letter!').downcase
      next unless @guess_attempt.match?(/[a-z]/)

      break
    end
    guess_checker
  end

  def guess_checker
    match_array = @word_array.each_index.select { |index| @word_array[index] == @guess_attempt }
    puts "#{match_array} guessing: #{@guess_attempt}"
    match_array.each do |index|
      @guess_array[index.to_i] = @guess_attempt
    end
  end

  def victory_check
    false
  end

  def initialize
    @guess_array = []
    CLI::UI::StdoutRouter.enable
    CLI::UI::Prompt.ask('New Game or Load Game?') do |handler|
      handler.option('New Game')  { new_game }
      handler.option('Load Game') do
        if File.exist?('savefile.txt')
          loader
        else
          puts 'Save file does not exist!'
          exit
        end
      end
    end
    play_round
  end
end

Hangman.new
