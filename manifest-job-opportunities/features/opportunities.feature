Feature: Opportunities
	Scenario: Filtering by location
		When I filter jobs by Columbus
		Then only Columbus opportunities are present

	Scenario: filtering by type
		When  filter jobs by contract
		Then only contract oportunities are present
