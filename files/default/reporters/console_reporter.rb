class ConsoleReporter
  def success(report)
    puts report
    puts 'Test Suite OK'
  end

  def fail(report)
    puts report
    puts 'Test Suite Failed'
  end
end