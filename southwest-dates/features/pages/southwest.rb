require 'page-object'
require 'byebug'
require 'date'

class SouthwestAirlines
  include PageObject

  page_url "https://www.southwest.com/"

  text_field(:departure_airport, :id => "air-city-departure")
  text_field(:arrival_airport, :id => "air-city-arrival")
  text_field(:departure_date_main_page, :id => "air-date-departure")
  text_field(:arrival_date_main_page, :id => "air-date-return")
  button(:search, :id => "jb-booking-form-submit-button")

  li(:departure_date_search_page, :id => 'carouselTodayDepart')
  li(:arrival_date_search_page, :id =>'carouselTodayReturn')

  ol(:visible_departure_days, css: "div#newDepartDateCarousel > ol")
  ol(:visible_days_from_arrival, css: "div#newReturnDateCarousel > ol")

  attr_accessor :departure_date_on_main_page
  attr_accessor :arrival_date_on_main_page

  def set_departure_date_on_main_page(dep_date)
    @@departure_date_on_main_page = dep_date
  end

  def set_arrival_date_on_main_page(arr_date)
    @@arrival_date_on_main_page = arr_date
  end

  def get_departure_date_on_main_page
    return @@departure_date_on_main_page.to_s
  end

  def get_arrival_date_on_main_page
    return @@arrival_date_on_main_page.to_s
  end

  def departure_date_matches_search_result
    dep_date_in_main = date_reformat_month_day(get_departure_date_on_main_page)
    dep_date_in_search = trim_string_to_show_only_date(departure_date_search_page)
    return dep_date_in_main == dep_date_in_search
  end


  def arrival_date_matches_search_result
    arr_date_in_main = date_reformat_month_day(get_arrival_date_on_main_page)
    arr_date_in_search = trim_string_to_show_only_date(arrival_date_search_page)
    return arr_date_in_main == arr_date_in_search
  end

  def date_reformat_month_day(date)
    return Date::MONTHNAMES[date[/\w*/].to_i] + " " + date[/\d*$/]
  end

  def trim_string_to_show_only_date(noisy_string)
    reformatted_string = noisy_string[/\w*\s\d+/]
    if (is_single_digit_day(reformatted_string))
      reformatted_string.insert(reformatted_string[/\D*/].length, '0')
    end
    return reformatted_string
  end

  def is_single_digit_day(reformatted_string)
    return reformatted_string[/\d*$/].length == 1
  end

  def past_departures_disabled_first_occurrence(date_today)
    are_days_disabled = true
    visible_departure_days_element.each do |past_day_info|
      is_day_disabled = check_past_day_disabled(past_day_info)
      if(still_in_past(past_day_info, date_today))
        break
      end
      if (is_day_disabled)
        next
      end
    end
    return are_days_disabled
  end

  def past_departures_disabled_second_occurrence(date_today)
    are_days_disabled = true
    visible_days_from_arrival_element.each do |past_day_info|
      is_day_disabled = check_past_day_disabled(past_day_info)
      if(still_in_past(past_day_info, date_today))
        break
      end
      if (is_day_disabled)
        next
      end
    end
    return are_days_disabled
  end

  def still_in_past(past_day_info, date_today)
    past_day = format_past_day(past_day_info)
    date_today = format_present_day(date_today)
    if (past_day != date_today)
      return false
    end
    return true
  end

  def format_past_day(past_day_info)
    past_day = past_day_info.text[/\w*\s\d+/]
    return past_day.upcase
  end

  def format_present_day(date_today)
    return date_today.upcase
  end

  def check_past_day_disabled(past_day_info)
    if (past_day_info.class_name != 'carouselDisabled')
      return false
    else
      return true
    end
  end
end
