require 'open-uri'
require 'nokogiri'
require 'tty-spinner'
require 'pastel'



def get_the_email_of_a_townhal_from_its_webpage(webpage)
	page = Nokogiri::HTML(open(webpage))
	page.css("td")[7].text
end

def get_all_the_urls_of_val_doise_townhalls 
	hash = {}
	page = Nokogiri::HTML(open("http://annuaire-des-mairies.com/val-d-oise.html"))
	page.css("a.lientxt").each do |a|
		hash[a.text] = "http://annuaire-des-mairies.com/#{a['href']}"
	end
	return hash
end

def get_all_the_emails_of_val_doise_townhalls
	array = []
	hash = get_all_the_urls_of_val_doise_townhalls
	hash.each do |k, v|
		h = {}
		h["name"] = k
		h["email"] = get_the_email_of_a_townhal_from_its_webpage (v)
		array << h
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
	puts get_all_the_emails_of_val_doise_townhalls
	spinner.success(pastel.green("done"))
end

perform
