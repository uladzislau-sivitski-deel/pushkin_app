namespace :db do
  task :parse => :environment do

    URL = "http://ilibrary.ru/text/"

    mechanize = Mechanize.new { |agent|
      agent.user_agent_alias = 'Linux Firefox'
    }

    page = mechanize.get("http://ilibrary.ru/author/pushkin/l.all/index.html")
    links = page.parser.css('.list a')

    id_poems = links.map { |l| l.attributes['href'].value.scan(/\d{3}/).join }
    id_poems = id_poems.drop(8) # drop links to categories

    num = 0
    size = id_poems.size

    id_poems.each do |id|
      link = URL + id + "/p.1/index.html"

      page = mechanize.get(link)

      title = page.parser.css('.title h1').text
      text = page.parser.css('.poem_main').text
      text.gsub!(/\u0097/, "\u2014") # replacement of unprintable symbol
      text.gsub!(/^\n/, "") # remove first \n

      puts "=".cyan*30
      puts title.green
      puts text.red
      puts "#{num} of #{size}".cyan
      num += 1

      poem = Poem.new
      poem.title = title
      poem.content = text
      poem.save
    end

  end

  task :add => :environment do
      poem = Poem.new
      poem.title = "Hello solar, son of a..."
      poem.content = "I hate you so much."
      poem.save
  end


  task :testReg => :environment do
  @question='Буря мглою небо кроет, Вихри %WORD% крутя'

    str1 = @question.gsub('%WORD%','')
    str2 = @question.split('%WORD%')[0]
    str3 = @question.split('%WORD%')[1]

    result = Poem.search do
      fulltext str1 do
      query_phrase_slop 1
    end
  end

    answer = result.results[0].content
    answer.gsub!(/[\n]/,' ')
    answer = answer[answer.index(str2),answer.index(str3)]
    answer.gsub!(str2,' ')
    puts answer

  end








end
