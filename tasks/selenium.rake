task "selenium:define_tasks" do
  Selenium::Rake::RemoteControlStartTask.new do |rc|
    rc.port = 4444
    rc.timeout_in_seconds = 120
    rc.background = true
    rc.wait_until_up_and_running = true
    rc.jar_file = File.join(File.dirname(__FILE__), "..", "bin", "selenium-server.jar")
    rc.additional_args << "-singleWindow"
  end

  Selenium::Rake::RemoteControlStopTask.new do |rc|
    rc.host = "localhost"
    rc.port = 4444
    rc.timeout_in_seconds = 3 * 60
  end
end

namespace :test do
  namespace :javascript do
    desc "Run the javascript tests in browser using selenium rc"
    task :selenium_rc => [:environment, "selenium:define_tasks", "selenium:rc:start"] do
      begin
        FileList["test/javascript/*_spec.js"].each do |spec_file|
          spec = File.basename(spec_file).gsub(/_spec\.js$/, "")
          SeleniumScrewUnitRunner.run(spec)
        end
        puts "#{SeleniumScrewUnitRunner.tests} tests, #{SeleniumScrewUnitRunner.failures} failures."
        raise "There were test case failures!" if SeleniumScrewUnitRunner.failures > 0
      ensure
        Rake::Task["selenium:rc:stop"].invoke unless ENV["keepseleniumrc"]
      end
    end
  end
end