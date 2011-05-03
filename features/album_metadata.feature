Feature: Image count
  In order to see be informed on albums stats
  As a user of the site
  I want to see the number of images next to every album

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

