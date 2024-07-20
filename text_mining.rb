#!/usr/bin/env ruby

# load library and utilities for searching via SerpApi
require 'google_search_results'

class Records
  """
  Represents records
  Attributes: 
  - titles of type Array and containing the titles of the papers extracted from the search page
  - links of type Array and containing the links of the papers extracted from the search page
  """
  attr_accessor :titles, :links
  def initialize(titles, links)
    @titles=Array(titles)
    @links=Array(links)
  end
end




"""
The function scholar_search:
- takesvar which represents the number of the results page
- makes a search in google scholar
- creates an instance of Records and stores papers titles and links
- writes the respective arrays obtained in the file scraping_scholar_results.txt
"""
def scholar_search(var)
  params={engine: "google_scholar", q:"kenya health open data hiv malaria maternal mental", start:var, api_key:"02ee41751eb42f8295d2efa378cb66cd4f75a06c9124b13b3b16f0600af37cc0"}
  search=GoogleSearch.new(params)
  organic_results=search.get_hash[:organic_results]
  total_records=Records.new([], [])
  organic_results.each do |result|
    total_records.titles=total_records.titles.push(result[:title])
    total_records.links=total_records.links.push(result[:link])
  end
  File.open("scraping_scholar_results.txt", "a") do |file|
    file.puts "New page of results"
    file.puts "The titles of the papers matching your query are: #{total_records.titles}"
    file.puts "The corresponding links are: #{total_records.links}"
    file.puts ""
  end
end


# execution of scholar_search for the first 20 pages and storage of data
first_twenty_pages=[0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 110, 120, 130, 140, 150, 160, 170, 180, 190]
first_twenty_pages.each do |i|
  scholar_search(i)
end

