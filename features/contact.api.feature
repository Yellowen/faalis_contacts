Feature: Contacts API
  In order to intract with contacts from dashboard
  Contacts API should be accessable by logged in users
  And anonymous user should not have accesss to API

  Scenario: Anonymous User should not have access to API
    Given I am not authenticated
    And there is a contact named "Iran" in database
    When format is json and I go to the api v1 contacts page
    Then I should get "401" status code
    When format is json and I go to "/api/v1/contacts/1"
    Then I should get "401" status code
    When format is json and I send patch to "/api/v1/contacts/1" with:
    """
    {"prefix":"HQhVrOxiqgzXyCgnRxPYZSbXTBFJJXDIIrFmbNYEUVTWSisilR","first_name":"LRfGVeslcIpXGusxUSoRQphMiVPijxuBBPQWDZxqqxYaOQdKdd","middle_name":"SxUEAaCtqwNGWNbXOYMBojkAmpjLkOLVOUgjwqgsEKeatBqDMp","last_name":"leyxfEervNPxPMKvrZRGkgjKuCTClKBPiHMDyPunHSJEDpRkVB","suffix":"DxnSEPyTWKZRxrVeCJTyQHQhfaSAGlkGAiMOcZJnLprCZJzNUm","organization":"NOMCwCAgfxfnFjUBQkqpOArSvhTglMEGksdLrrNcRmtROkraND","is_organization":"VLkZETIeHjKxXfXZSfbJeYBdRkbDXpvKOjAIhKGLUaLrHszXbx"}
    """
    Then I should get "401" status code
    When format is json and I send post to "/api/v1/contacts" with:
    """
    {"prefix":"eUDlBTjIboCYYcDhdKWPpQGwlhtAIjfbBCMaZxcTWILywlbYJE","first_name":"UGCPoUaMMRcBgKjpqTAOSrxONzhoTRFDbgacFknhRDreTXqDow","middle_name":"JPOTsijIicTgAvURRsKOPKDWvdfWotXDaGQMewtpqSSocHXeMp","last_name":"wcvUDqsKyWKEnAiDxfLKugLZYQlAUpLOVPCFwskOqmBiFQLUIv","suffix":"kHPMZyrWxqwzdkALosaffjKoZjXpaZzLPPCVasbFFqNhOwfpFu","organization":"FTvDYjiGfmWDyyjQkwdvbVNLkUJFIkKYMLdgSGcAuAcVmshGUN","is_organization":"SQIodBpVbmipJBUPayiUZjmMajXpIpbQjPytAInjQAswFUPLCS"}
    """
    Then I should get "401" status code
    When format is json and I send delete to "/api/v1/contacts/1"
    Then I should get "401" status code

  Scenario: Default response should be json
    Given I am authenticated
    When I go to the api v1 contacts page
    Then response type should be application/json

  Scenario: Anonymous User via HTTP
    Given I am not authenticated
    When format is html and I go to the api v1 contacts page
    Then I should be in sign in page

  Scenario: Anonymous USer via JSON format
    Given I am not authenticated
    When format is json and I go to the api v1 contacts page
    Then I should get "401" status code

  Scenario: Logged in User via HTTP
    Given I am authenticated
    When format is html and I go to the api v1 contacts page
    Then I should get unknown format exception
    #Then I should get "406" status code

  Scenario: Logged in User via JSON format
    Given I am authenticated
    When format is json and I go to the api v1 contacts page
    Then the JSON should have 0 keys

  Scenario: Logged in User via JSON format And Initial Data
    Given I am authenticated
    And there is a contact named "XYZ" in database
    When format is json and I go to the api v1 contacts page
    Then the JSON should have 1 keys
    And the JSON at "0/name" should be "XYZ"

  Scenario: API should not response to "/new"
    Given I am authenticated
    When format is json and I go to "/api/v1/contacts/new"
    Then action should not be found

  @javascript
  Scenario: Add New contact
    Given I am authenticated
    When I go to "/dashboard#/contacts/new"
    And fill in "name" with "XYZ"
    And click on "save"
    And wait for ajax to return
    Then there should be a contact with "XYZ" as "name"

  @javascript
  Scenario: Edit contact
    Given I am authenticated
    And there shouldn't be any contact
    And there is a contact named "XYZ" in database
    Then there should be a contact with "XYZ" as "name"
    When I go to "/dashboard#/contacts/1/edit"
    And fill in "name" with "XYZW"
    Then field "name" contains "XYZW"
    When click on "save"
    And wait for ajax to return
    Then there should be a contact with "XYZW" as "name"

  Scenario: Delete contact
    Given I am authenticated
    And there is a contact named "ABC" in database
    And there is a contact named "XYZ" in database
    When format is json and I send delete to "/api/v1/contacts/1,2"
    Then the JSON at "msg" should be "Items removed successfully."
    And there shouldn't be any contact
