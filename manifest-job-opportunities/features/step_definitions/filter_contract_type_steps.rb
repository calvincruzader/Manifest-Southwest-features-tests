require 'watir-webdriver'
require 'page-object'
require 'byebug'
require 'rspec'

include PageObject::PageFactory

When(/^filter jobs by contract$/) do
  visit_page ManifestAllOpportunitiesPage
  on_page ManifestAllOpportunitiesPage do |page|
    page.select_type_contract

    page.wait_until do
      page.current_url.include? "opportunity_type=contract"
    end
    
    expect(page.current_url).to include("opportunity_type=contract")
  end
end

Then(/^only contract oportunities are present$/) do
  on_page ManifestAllOpportunitiesPage do |page|
    expect(page.has_only_opportunities_by_contract).to be true
  end
end
