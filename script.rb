require 'mysql2'
class Script
  def initialize
	@client = Mysql2::Client.new(host: 'db09', username: 'loki', password: 'v4WmZip2K67J6Iq7NXC', database: 'applicant_tests')
  end

  def insert(id, clean_name, sentence)
    @client.query("Update hle_dev_test_igor_lobazov
                       Set clean_name = \"#{clean_name}\", sentence = \"#{sentence}\"
                       Where id = \"#{id}\";")
  end
  def results
    @client.query("SELECT * FROM hle_dev_test_igor_lobazov;")
  end


  def fill
    results.each do |result|
      @raw_string = result["candidate_office_name"]
      clean_name = compare
      sentence = "The candidate is running for the #{clean_name} office."
      insert(result['id'], clean_name, sentence)
    end
  end



def compare

if @raw_string.include?('(') || @raw_string.include?(')') 
	paranthes
end
 
right_name

end



def paranthes


@raw_string.split(',').first + " " + '()'.insert(1,@raw_string.partition(', ').last)

end

def downcase_and_unique

@raw_string.downcase.split.reverse.uniq.reverse.join(' ').tr('.', '')

end


def short_name_convert

if downcase_and_unique.include?('twp') 

downcase_and_unique.gsub('twp', 'Township')

elsif downcase_and_unique.include?('hwy') || downcase_and_unique.include?('highway') 

downcase_and_unique.gsub("hwy", 'Highway')
downcase_and_unique.gsub("highway", 'Highway')
else
return downcase_and_unique
end
end

def right_name
head = @raw_string.split('/').last

tail = short_name_convert.split('/').reverse.uniq.drop(1).reverse.join(' ')

@name = head + " " + tail


if @raw_string.split.size > 2 

@name.split(' ').insert(-2, 'and').join(' ')

end
end
end


script = Script.new
script.fill
