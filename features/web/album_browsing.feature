Feature: Album browsing
  In order to see images grouped into albums
  As a user of the site
  I want to browse photo albums

  Scenario: Front page albums
    Given there is an album "Album 1"
    And there is an album "Album 2"
    When I go to the home page
    Then I should see "Album 1"
    And I should see "Album 2"

  Scenario: Album shows nested albums
    Given there is an album "Outer" in the root
    And there is an album "Inner" inside "Outer"
    When I go to the home page
    And I follow "Outer"
    Then I should see "Subalbums"
    And I should see "Inner"

  Scenario: Album with no children shows no subalbums
    Given there is an album "Outer" in the root
    And there is an album "Inner" inside "Outer"
    When I go to the home page
    And I follow "Outer"
    And I follow "Inner"
    Then I should see header "Inner"
    And I should not see "Subalbums"
