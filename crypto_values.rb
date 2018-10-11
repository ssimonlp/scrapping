# frozen_string_literal: true

require 'nokogiri'
require 'open-uri'
require 'tty-spinner'
require 'pastel'

def get_cryptos
  array = []
  webpage = Nokogiri::HTML(open("https://coinmarketcap.com/all/views/all/"))
  webpage.css('tbody>tr').each do |row|
    hash = {}
    hash['Currency'] = row.css('.currency-name')[0]['data-sort']
    hash['Price'] = row.css('.text-right')[1]['data-sort']
    array << hash
  end
  array
end

def perform
  pastel = Pastel.new
  format = "[#{pastel.red(':spinner')}] " + pastel.red("Scrapping ...")
  spinner = TTY::Spinner.new(format, success_mark: pastel.green('+'))
  20.times do
    spinner.spin
    sleep(0.1)
  end
  puts get_cryptos
  spinner.success(pastel.green("Successful"))
end

loop do
  perform
  sleep(3600)
end
