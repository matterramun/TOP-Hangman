# frozen_string_literal: true

require 'cli/ui'

def loader
  puts 'Loading...'
end

def new_game
  word = generate_word
  word_array = word.chars
  guess_array = Array.new(word_array.length) { |i| i = '_' }
  puts "#{word} #{word_array.length} #{guess_array}"
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
  loop do
    guess_attempt = CLI::UI.ask('Guess a letter!').downcase
    next unless guess_attempt.match?(/[a-z]/)

    return
  end
  guess_attempt
end

def victory_check
  false
end

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
  play_round
end
