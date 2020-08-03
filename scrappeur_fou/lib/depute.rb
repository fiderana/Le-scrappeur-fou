require 'rubygems'
require 'nokogiri'
require 'open-uri'

#page source
def get_urls_depute
  page = Nokogiri::HTML(open("http://www2.assemblee-nationale.fr/deputes/liste/alphabetique"))
  urls = page.xpath("//div/div[3]/div/ul/li/a/@href").map {|url| "http://www2.assemblee-nationale.fr" + url}
end

#methode pour obtenir les mails des député
def get_depute_email(page)
  page.xpath("//a[starts-with(@href, 'mailto')]/text()")[1].text
end

#fonction pour obtenir le prénom de chaque député
def get_depute_first_name(page)
  first_name = []
  array = page.xpath("//article/div[2]/h1").text.split(" ")
  array.delete_at(0)
  first_name << array[0]
  first_name.join
end

#fonction pour le nom
def get_depute_last_name(page)
  array = page.xpath("//article/div[2]/h1").text.split(" ")
  array.delete_at(0)
  array.delete_at(0)
  array.join(" ")
end

#tableau de nom, prénom et email des députés
def hash_depute(get_depute_first_name,get_depute_last_name,get_depute_email)
  hash_temp = Hash.new
  hash_temp["first_name"]=get_depute_first_name
  hash_temp["last_name"]=get_depute_last_name
  hash_temp["email"]=get_depute_email
  hash_temp
end

def perform #ensembe de toutes les fonctions pour obtenir une array de hashs de chaque député
  depute = get_urls_depute.map do |url|
    page = Nokogiri::HTML(open(url))
    hash_depute(get_depute_first_name(page),get_depute_last_name(page),get_depute_email(page))
    puts hash_depute(get_depute_first_name(page),get_depute_last_name(page),get_depute_email(page))
  end
  depute
end

perform
