Feature: Album metadata
  In order to see be informed on albums information
  As a user of the site
  I want to see album metadata when browsing the site

  Scenario: Front page albums
    Given there is an album "Album 1"
    And the album has description: "An album"
    And the album has 5 photos
    When I go to the home page
    Then I should see "Album 1"
    And I should see "An album"
    And I should see "5 photos"

  Scenario: Viewing album
    Given there is an album "Album 1"
    And the album has description: "An album"
    And the album has 5 photos
    When I go to the album page
    Then I should see "Album 1"
    And I should see "An album"
    And I should see "5 photos"

