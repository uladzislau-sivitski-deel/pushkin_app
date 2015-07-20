class QuizController < ApplicationController
skip_before_filter :verify_authenticity_token, :only => [:index]
TOKEN = '34291703b59f5c7e827d31116f0bf161'.freeze

  def index

 render nothing: true
 @question =params[:question]
 @id = params[:id]


  if params[:level] == 1
  results = Poem.content(@question)


if results[0]==nil
  answ = results.title
else
  answ = results.first.title
end





  end

   if params[:level] == 2
 str1 = @question.gsub('%WORD%','')
  str2 = @question.split('%WORD%')[0]
  str3 = @question.split('%WORD%')[1]

  results = Poem.content(str1)


  if results[0]==nil
  answ = results.content
else
  answ = results.first.content
end


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
  end


if params[:level] == 3

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
  end

  if params[:level] == 4

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
  end

  if params[:level] == 5

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
  end

  if params[:level] > 5
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
  end


   uri = URI("http://pushkin.rubyroidlabs.com/quiz")
  parameters = {
    answer: answ,
    token: TOKEN,
    task_id:  @id
  }
  Net::HTTP.post_form(uri, parameters)

  end
end
