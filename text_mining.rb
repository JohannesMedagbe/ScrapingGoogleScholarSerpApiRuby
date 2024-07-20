#!/usr/bin/env ruby

# load library and utilities for searching via SerpApi and csv
require 'google_search_results'
require 'csv'

class Records
  """
  Represents records
  Attributes: 
  - titles of type Array and containing the titles of the papers extracted from the search page
  - links of type Array and containing the links of the papers extracted from the search page
  - snippets of type Array and containing the snippets of the papers extracted from the search page
  - focus of type Array and return disease of focus
  - open of type Array and return yes or no if the paper is FAIR compliant
  """
  attr_accessor :titles, :links, :snippets, :concepts, :focus, :open
  def initialize(titles, links, snippets, focus, open)
    @titles=Array(titles)
    @links=Array(links)
    @snippets=Array(snippets)
    @focus=Array(focus)
    @open=Array(open)
  end
end


# extract the focus of a text of type String
def focus(text)
  if text =~ /malaria|Malaria/
    return "malaria"
  elsif text =~ /HIV|hiv/
    return "HIV"
  elsif text =~ /maternal|Maternal/
    return "maternal disease"
  elsif text =~ /mental|Mental/
    return "mental disease"
  else
    return "unknown"
  end
end

# determine if a resource is open based on the file format
def open_resource(resource)
  if resource
    return "True"
  else
    return "False"
  end
end

"""
The function scholar_search:
- takes var which represents the number of the results page
- makes a search in google scholar
- creates an instance of Records and stores titles, snippets, links, common concepts and open
- writes the respective arrays obtained in the files scraping_scholar_results.txt and scraping_scholar_results.csv
"""
def scholar_search(var)
  params={engine: "google_scholar", q:"kenya health open data hiv malaria maternal mental", start:var, api_key:"02ee41751eb42f8295d2efa378cb66cd4f75a06c9124b13b3b16f0600af37cc0"}
  search=GoogleSearch.new(params)
  organic_results=search.get_hash[:organic_results]
  
  total_records=Records.new([], [], [], [], [])
  
  organic_results.each do |result|
    total_records.titles=total_records.titles.push(result[:title])
    total_records.links=total_records.links.push(result[:link])
    total_records.snippets=total_records.snippets.push(result[:snippet])
    total_records.focus=total_records.focus.push(focus(result[:snippet]))
    total_records.open=total_records.open.push(open_resource(result[:resources]))
  end
  
  File.open("scraping_scholar_results.txt", "a") do |file|
    file.puts "New page of results"
    file.puts ""
    file.puts "The titles of the papers matching your query are: #{total_records.titles}"
    file.puts ""
    file.puts "The corresponding links are: #{total_records.links}"
    file.puts ""
    file.puts "The corresponding abstracts snippets are: #{total_records.snippets}"
    file.puts ""
    file.puts "The corresponding research focuses are: #{total_records.focus}"
    file.puts ""
    file.puts "The corresponding FAIR statuses are: #{total_records.open}"
    file.puts ""
  end
  
  
  table= [total_records.titles, total_records.links, total_records.snippets, total_records.focus, total_records.open].transpose
  CSV.open("scraping_scholar_results.csv", "a") do |csv|
    table.each do |row|
      csv << row
    end
  end
end


# execution of scholar_search for the first 20 pages and storage of data
first_twenty_pages=[0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 110, 120, 130, 140, 150, 160, 170, 180, 190]
first_twenty_pages.each do |i|
  scholar_search(i)
end
