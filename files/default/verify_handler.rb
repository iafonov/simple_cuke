class VerifyHandler < Chef::Handler
  def initialize(options)
    @path = options[:path]
    @excluded_roles = options[:all_roles] - options[:node_roles]
  end

  def report
    if run_tests
      puts "\033[32mTest Suite OK\033[30m"
    else
      puts "\033[31mTest Suite Failed\033[30m"
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
end