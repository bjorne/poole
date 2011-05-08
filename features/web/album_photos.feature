Feature: Album photos
  In order to be amazed by the beautiful photos on the site
  As a user of the site
  I want to see photos in the albums

  Scenario: Album photo thumbnails
    Given there is an album "Album 1"
    And the album has a photo file "DSC_1.jpg"
    And the album has a photo file "DSC_2.jpg"
    When I go to the album page
    Then I should see a photo thumbnail "DSC_1.jpg"
    And I should see a photo thumbnail "DSC_2.jpg"
    
