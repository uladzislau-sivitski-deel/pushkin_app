class QuizController < ApplicationController
skip_before_filter :verify_authenticity_token, :only => [:index]
TOKEN = '34291703b59f5c7e827d31116f0bf161'.freeze

  def index

 render nothing: true
 @question=params[:question]
  @id = params[:id]


  if params[:level] == 1
  results = Poem.content(@question)
  answ = results.first.title
  end

   if params[:level] == 2
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
  end

     if params[:level] == 3
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
