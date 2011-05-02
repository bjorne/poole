Feature: Browsing
  In order to see all photo albums
  As a user of the site
  I want to browse photo albums

  Scenario: Front page albums
    Given there is an album with title "Album 1"
    And there is an album with title "Album 2"
    When I go to the home page
    Then I should see "Album 1"
    And I should see "Album 2"

  Scenario: Nested albums
    Given there is an album with title "Outer" in the root
    And there is an album with title "Inner" inside "Outer"
    When I go to the home page
    And I follow "Outer"
    Then I should see "Subalbums"
    And I should see "Inner"
