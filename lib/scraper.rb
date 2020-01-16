require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    index_html= Nokogiri::HTML(open(index_url))
    students= []
    index_html.css("div.roster-cards-container").each do |student_card|
      student_card.css(".student-card a").each do |student|
        student_profile_url= "#{student.attr('href')}"
        student_location= student.css(".student-location").text
        student_name= student.css(".student-name").text
        students << {name: student_name, location: student_location, profile_url: student_profile_url}
      end
    end
    students
  end

  def self.scrape_profile_page(profile_url)
    profile_html= Nokogiri::HTML(open(profile_url))
    student= {}
    links= profile_html.css(".social-icon-container").children.css("a").map {|e| e.attribute("href").value}
    links.each do |link|
      if link.include?("linkedin")
        student[:linkedin]= link
      elsif link.include?("github")
        student[:github]= link
      elsif link.include?("twitter")
        student[:twitter]= link
      else
        student[:blog]= link
      end
    end
    student[:profile_quote] = profile_html.css(".profile-quote").text if profile_html.css(".profile-quote")
    student[:bio] = profile_html.css("div.bio-content.content-holder div.description-holder p").text if profile_html.css("div.bio-content.content-holder div.description-holder p")
    student
  end

end
