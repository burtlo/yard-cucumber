module CucumberLocationHelper

  def line_number
    files.first.last
  end

  def file
    files.first.first
  end

  def location
    "#{files.first.first}:#{files.first.last}"
  end

end