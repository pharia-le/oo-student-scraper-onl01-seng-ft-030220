require 'nokogiri'
require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    students_array = []
    html = Nokogiri::HTML(open(index_url))
    html.css(".roster-cards-container").each do |containers|
      containers.css(".student-card a").each do |student_info|
        student = {}
        student[:name] = student_info.css("h4.student-name").text
        student[:location] = student_info.css("p.student-location").text
        student[:profile_url] = student_info.attr("href")
        students_array << student
      end
    end
    students_array
  end

  def self.scrape_profile_page(profile_url)
    student_hash = {}
    html = Nokogiri::HTML(open(profile_url))
    html.css(".social-icon-container a").each do |social_icon|
      url = social_icon.attr("href")
      student_hash[:twitter] = url if url.include?("twitter")
      student_hash[:linkedin] = url if url.include?("linkedin")
      student_hash[:github] = url if url.include?("github")
      student_hash[:blog] = url if social_icon.css("img.social-icon").attr("src").text.include?("rss")
    end
    student_hash[:profile_quote] = html.css("div.profile-quote").text
    student_hash[:bio] = html.css("div.description-holder p").text
    student_hash
  end

end

