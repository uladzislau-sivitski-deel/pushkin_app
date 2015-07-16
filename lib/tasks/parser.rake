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

   task :testQ22 => :environment do

TOKEN = '34291703b59f5c7e827d31116f0bf161'.freeze
  @question='Она %WORD% поет,\\n%WORD% соловей близ тихих вод '
  @id = '111'

 sear =

 strings = @question.split(/[\n]/)

 strings.each do |str|
 str1 = str.gsub('%WORD%','')
  str2 = str.split('%WORD%')[0]
  str3 = str.split('%WORD%')[1]

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








end
