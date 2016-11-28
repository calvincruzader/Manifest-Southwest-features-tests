require 'watir-webdriver'
require 'page-object'
require 'byebug'

class ManifestAllOpportunitiesPage
  include PageObject

  page_url "http://manifestcorp.com/opportunities/all-opportunities/"

  DROPDOWN_COLUMBUS_INDEX = 1;
  DROPDOWN_CONTRACT_INDEX = 2;

  select_list(:location_filter, :name => 'opportunity_loc')
  divs(:opportunities_locations, :class => 'opp-loc')

  select_list(:type_filter, :name => 'opportunity_type')
  divs(:opportunities_types, :class => 'opp-type')

  def select_location_columbus
    location_filter_element[DROPDOWN_COLUMBUS_INDEX].click
  end

  def has_only_opportunities_in_columbus
    opportunities_locations_elements.each do |loc|
      opportunity_location = loc.text
      if (opportunity_location != "Columbus, OH") then
        return false
      end
    end
    return true
  end

  def select_type_contract
    type_filter_element[DROPDOWN_CONTRACT_INDEX].click
  end

  def has_only_opportunities_by_contract
    opportunities_types_elements.each do |type|
      opportunity_type = type.text
      if(opportunity_type != "Contract") then
        return false
      end
    end
    return true
  end
end
