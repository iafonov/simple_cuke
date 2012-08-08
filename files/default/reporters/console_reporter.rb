class ConsoleReporter
  def success(report)
    puts report
    puts green('Test Suite OK')
  end

  def fail(report)
    puts report
    puts red('Test Suite Failed')
  end

private

  def red(text); colorize(text, "\e[31m"); end
  def green(text); colorize(text, "\e[32m"); end

  def colorize(text, color_code)
    "#{color_code}#{text}\e[0m"
  end
end