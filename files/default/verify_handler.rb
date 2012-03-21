class VerifyHandler < Chef::Handler
  def initialize(options)
    @path = options[:path]
    @excluded_roles = options[:all_roles] - options[:node_roles]
  end

  def report
    puts green("Running test suite in #{@path}")
    if run_tests
      puts green("Test Suite OK")
    else
      puts red("Test Suite Failed")
    end
  end

private

  def install_bundle
    `cd #{@path} && bundle install`
  end

  def run_tests
    system("cd #{@path} && bundle exec cucumber --tags #{roles_tags}")
  end

  def roles_tags
    @excluded_roles.map{|role| "~@#{role}"}.join(",")
  end

  def green(str)
    "\033[32m#{str}\033[30m"
  end

  def red(str)
    "\033[31m#{str}\033[30m"
  end
end