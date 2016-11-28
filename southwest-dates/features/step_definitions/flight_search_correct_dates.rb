require 'watir-webdriver'
require 'page-object'
require 'byebug'

include PageObject::PageFactory

When(/^I search for a flight using the default dates$/) do
  visit_page SouthwestAirlines
  on_page SouthwestAirlines do |page|
    page.departure_airport = "CMH"
    page.arrival_airport = "LGA"

    departure_date = page.departure_date_main_page
    arrival_date = page.arrival_date_main_page
    page.set_departure_date_on_main_page(departure_date)
    page.set_arrival_date_on_main_page(arrival_date)

    page.search

    @browser.li(id: "carouselTodayDepart").wait_until_present
    @browser.li(id: "carouselTodayReturn").wait_until_present
    @browser.ol(css: "div#newDepartDateCarousel > ol").wait_until_present
    @browser.ol(css: "div#newReturnDateCarousel > ol").wait_until_present
  end
end

Then(/^the dates I searched for are highlighted in the search results$/) do
  on_page SouthwestAirlines do |page|
    expect(page.departure_date_matches_search_result).to be true
    expect(page.arrival_date_matches_search_result).to be true
  end
end

And(/^I can't choose a departure date from the past$/) do
  on_page SouthwestAirlines do |page|
    expect(page.past_departures_disabled_first_occurrence(Date.today.strftime('%B %d'))).to be true
    expect(page.past_departures_disabled_second_occurrence(Date.today.strftime('%B %d'))).to be true
  end
end
