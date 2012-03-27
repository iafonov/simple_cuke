class ConsoleReporter
  def success(report)
    puts report
    green("Test Suite OK")
  end

  def fail(report)
    puts report
    red("Test Suite Failed")
  end

private

  def green(str)
    puts "\033[32m#{str}\033[30m"
  end

  def red(str)
    puts "\033[31m#{str}\033[30m"
  end
end