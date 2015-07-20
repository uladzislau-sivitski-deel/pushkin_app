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

    task :parseLines => :environment do

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


      lines = text.split(/[\n]/)

      lines.each do |lin|
      line = Line.new
      line.title = title
      line.content = lin
      line.save
    end
    end

  end

 task :parseLinesS => :environment do

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


      lines = text.split(/[\n]/)

      lines.each do |lin|

      line = Sortline.new
      line.title = title

      lin = lin.chars.sort.join
      lin = lin.lstrip
      lin = lin.split(//).reject { |s| s =~ /[[:punct:]]/ }.join
      line.content = lin

      line.save
    end
    end

  end




  task :testReg => :environment do
  @question='Буря мглою небо кроет, Вихри  крутя'

    str1 = @question.gsub('%WORD%','')
    str2 = @question.split('%WORD%')[0]
    str3 = @question.split('%WORD%')[1]



    result = Poem.search query: { match_phrase:  { content: {query: "Буря мглою небо кроет, Вихри крутя", slop: 1} } }

    answer = result.first.content
    answer.gsub!(/[\n]/,' ')
    answer = answer[answer.index(str2),answer.index(str3)]
    answer.gsub!(str2,' ')
    puts answer



     @question=params[:question]
  @id = params[:id]

  results = Poem.content(@question)


  uri = URI("http://pushkin-contest.ror.by/quiz")

 parameters = {
  answer: results.first.title,
  token: TOKEN,
  task_id:  @id
 }

  end

    task :testQ1 => :environment do

TOKEN = '34291703b59f5c7e827d31116f0bf161'.freeze
  @question='О други, Августу мольбы мои несите'
  @id = '111'

  results = Poem.content(@question)

  puts results.first.title

  uri = URI("http://pushkin-contest.ror.by/quiz")

 parameters = {
  answer: results.first.title,
  token: TOKEN,
  task_id:  @id
 }

 puts parameters


  end

      task :testQ2 => :environment do

TOKEN = '34291703b59f5c7e827d31116f0bf161'.freeze
  @question='%WORD% приятнее поет'
  @id = '111'

 str1 = @question.gsub('%WORD%','')
  str2 = @question.split('%WORD%')[0]
  str3 = @question.split('%WORD%')[1]

  results = Poem.content(str1)
  answ = results.first.content
  answ.gsub!(/[\n]/,' ')

  answ = answ[answ.index(str2), answ.index(str3)]
  answ = answ[answ.index(str2), answ.index(str3)]
  answ.gsub!(str2,' ')

   uri = URI("http://pushkin-contest.ror.by/quiz")

 parameters = {
  answer: answ.lstrip,
  token: TOKEN,
  task_id:  @id
 }

 puts parameters

  end

        task :testQ22 => :environment do

TOKEN = '34291703b59f5c7e827d31116f0bf161'.freeze
  @question='Она приятнее %WORD% '
  @id = '111'

 str1 = @question.gsub('%WORD%','')
  str2 = @question.split('%WORD%')[0]
  str3 = @question.split('%WORD%')[1]

  results = Poem.content(str1)
  answ = results.first.content
  answ = answ.split(/[\n]/)


  answ.each do |str|
    if str.include?(str2) && str.include?(str3)
       answ = str
       break
    end
  end

answ = answ.gsub(str2,'')
answ = answ.gsub(str3,'')
answ = answ.strip.gsub(/[[:punct:]]\z/, '')

   uri = URI("http://pushkin-contest.ror.by/quiz")

 parameters = {
  answer: answ.lstrip,
  token: TOKEN,
  task_id:  @id
 }
 puts parameters

  end

   task :testQ3 => :environment do

TOKEN = '34291703b59f5c7e827d31116f0bf161'.freeze
  @question="Но по %WORD% остроте,\nНо по приветствиям %WORD%,"
  @id = '111'
  @pos = 0
 arr = @question.split(/[\n]/)

 str1 = @question.gsub('%WORD%','')

 str1 = str1.gsub(/[\n]/,' ')


 results = Poem.content(str1)
 answ = results.first.content
 answ = answ.split(/[\n]/)

str2 = arr[0].split('%WORD%')[0]
str3 = arr[0].split('%WORD%')[1]

if str3 == nil
  str3=''
end


  answ.each do |str|
    @pos+=1
    if str.include?(str2) && str.include?(str3)
       answ[0] = str
       answ[1] = answ[@pos]
       break
    end
  end

answ[0] = answ[0].gsub(str2,'')
if str3 != nil
  answ[0] = answ[0].gsub(str3,'')
end
answ[0] = answ[0].strip.gsub(/[[:punct:]]\z/, '')


str2 = arr[1].split('%WORD%')[0]
str3 = arr[1].split('%WORD%')[1]
answ[1] = answ[1].gsub(str2,'')
if str3 != nil
  answ[1] = answ[1].gsub(str3,'')
end
answ[1] = answ[1].strip.gsub(/[[:punct:]]\z/, '')





answ = answ[0] +','+answ[1]

   uri = URI("http://pushkin-contest.ror.by/quiz")

 parameters = {
  answer: answ,
  token: TOKEN,
  task_id:  @id
 }
 puts parameters

  end

     task :testQ4 => :environment do

TOKEN = '34291703b59f5c7e827d31116f0bf161'.freeze
  @question="%WORD% гусарские затеи,\nКак я с Кавериным %WORD%,\n%WORD% Россию с Молоствовым,"
  @id = '111'
@pos = 0
 arr = @question.split(/[\n]/)

 str1 = @question.gsub('%WORD%','')

 str1 = str1.gsub(/[\n]/,' ')


 results = Poem.content(str1)


 if results[0]==nil
  answ = results.content
else
  answ = results.first.content
end



 answ = answ.split(/[\n]/)

str2 = arr[0].split('%WORD%')[0]
str3 = arr[0].split('%WORD%')[1]

if str3 == nil
  str3=''
end


  answ.each do |str|
    @pos+=1
    if str.include?(str2) && str.include?(str3)
       answ[0] = str
       answ[1] = answ[@pos]
       answ[2] = answ[@pos+1]
       break
    end
  end

answ[0] = answ[0].gsub(str2,'')
if str3 != nil
  answ[0] = answ[0].gsub(str3,'')
end
answ[0] = answ[0].strip.gsub(/[[:punct:]]\z/, '')


str2 = arr[1].split('%WORD%')[0]
str3 = arr[1].split('%WORD%')[1]
answ[1] = answ[1].gsub(str2,'')
if str3 != nil
  answ[1] = answ[1].gsub(str3,'')
end
answ[1] = answ[1].strip.gsub(/[[:punct:]]\z/, '')

str2 = arr[2].split('%WORD%')[0]
str3 = arr[2].split('%WORD%')[1]
answ[2] = answ[2].gsub(str2,'')
if str3 != nil
  answ[2] = answ[2].gsub(str3,'')
end
answ[2] = answ[2].strip.gsub(/[[:punct:]]\z/, '')


answ = answ[0] +','+answ[1]+','+answ[2]

   uri = URI("http://pushkin-contest.ror.by/quiz")

 parameters = {
  answer: answ,
  token: TOKEN,
  task_id:  @id
 }
 puts parameters

  end



  task :testQ5 => :environment do

TOKEN = '34291703b59f5c7e827d31116f0bf161'.freeze
@question="В сотрудники статьи вызвался Поповский,"
@id = '111'

 results = Line.strictly_spelled_like(@question)

 if results[0]==nil
  answ = results.content
else
  answ = results.first.content
end
@question = @question.split(' ')
answ = answ.split(' ')
answer1 = (@question - answ).join.split(//).reject { |s| s =~ /[[:punct:]]/ }.join
answer2 = (answ - @question).join.split(//).reject { |s| s =~ /[[:punct:]]/ }.join
answ = answer2 +','+answer1

uri = URI("http://pushkin-contest.ror.by/quiz")

 parameters = {
  answer: answ,
  token: TOKEN,
  task_id:  @id
 }
 puts parameters

  end

task :testQ6 => :environment do

TOKEN = '34291703b59f5c7e827d31116f0bf161'.freeze
@question="Сааааавдддзикклллммооооррсттууцыь"
@id = '111'

      @question = @question.chars.sort.join
      @question = @question.lstrip
      @question = @question.split(//).reject { |s| s =~ /[[:punct:]]/ }.join

 results = Sortline.strictly_spelled_like(@question)

 if results[0]==nil
  answ = results.id
else
  answ = results.first.id
end

results = Line.find(answ)

 if results[0]==nil
  answ = results.content
else
  answ = results.first.content
end

answ = answ.split(//).reject { |s| s =~ /[[:punct:]]/ }.join



uri = URI("http://pushkin-contest.ror.by/quiz")

 parameters = {
  answer: answ,
  token: TOKEN,
  task_id:  @id
 }
 puts parameters

  end











end
