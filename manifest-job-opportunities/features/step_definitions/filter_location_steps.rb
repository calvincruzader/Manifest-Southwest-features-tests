require 'watir-webdriver'
require 'page-object'
require 'byebug'
require 'rspec'

include PageObject::PageFactory

When(/^I filter jobs by Columbus$/) do
  visit_page ManifestAllOpportunitiesPage
  on_page ManifestAllOpportunitiesPage do |page|
    page.select_location_columbus

    page.wait_until do
      page.current_url.include? "opportunity_loc=Columbus--OH"
    end

    expect(page.current_url).to include("opportunity_loc=Columbus--OH")
  end
end

Then(/^only Columbus opportunities are present$/) do
  on_page ManifestAllOpportunitiesPage do |page|
    expect(page.has_only_opportunities_in_columbus).to be true
  end
end
