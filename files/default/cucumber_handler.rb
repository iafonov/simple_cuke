class CucumberHandler < Chef::Handler  
  def initialize(options)
    @suite_path = options[:suite_path]
    @reporters_path = options[:reporters_path]
    @excluded_roles = options[:all_roles] - options[:node_roles]
    @reporter = load_reporter(options[:reporter] || :console)
  end

  def report
    return if @reporter.nil?

    install_bundle
    result, report = run_tests

    result ? @reporter.success(report) : @reporter.fail(report)
  end

private

  def install_bundle
    `cd #{@suite_path} && bundle install --deployment`
  end

  def run_tests
    report = `cd #{@suite_path} && bundle exec cucumber --tags #{roles_tags}`
    return $?.success?, report
  end

  def load_reporter(name)
    require File.join(@reporters_path, "#{name}_reporter.rb")

    Object.const_get("#{name.to_s.capitalize}Reporter").new
  rescue LoadError
    Chef::Log.error("Reporter file wasn't found in #{@reporters_path}")
    nil
  rescue NameError
    Chef::Log.error("Reporter class definition is invalid")
    nil
  end

  def roles_tags
    @excluded_roles.map{|role| "~@#{role}"}.join(",")
  end
end