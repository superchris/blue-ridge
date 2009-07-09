require "selenium/client"

class SeleniumScrewUnitRunner
  class << self
    attr_accessor :tests, :failures
    def browser
      SeleniumDriverManager.driver
    end

    def run(spec)
      self.tests ||= 0
      self.failures ||= 0
      browser.open("file:///#{RAILS_ROOT}/test/javascript/fixtures/#{spec}.html")
      browser.wait_for_no_text("Running", :element => "css=.status")
      browser.wait_for_element "test_failures"
      test_failures = browser.get_text("test_failures").to_i
      test_count = browser.get_text("test_count").to_i
      self.tests += test_count
      self.failures += test_failures
      self.failures.times do |i|
        puts "Failure: " + browser.get_text("failure_#{i}")
      end
    end
    
  end

end
