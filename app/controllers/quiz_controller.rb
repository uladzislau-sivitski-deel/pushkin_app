class QuizController < ApplicationController
skip_before_filter :verify_authenticity_token, :only => [:index]
TOKEN = '34291703b59f5c7e827d31116f0bf161'.freeze

  def index

 render nothing: true

  if params[:level] == 1
  @question=params[:question]
  @id = params[:id]
  results = Poem.content(@question)
  answ = results.first.title
  end

   if params[:level] == 2
  str1 = @question.gsub('%WORD%','')
  str2 = @question.split('%WORD%')[0]
  str3 = @question.split('%WORD%')[1]

  results = Poem.content(str1)
  answ = results.first.content
  answ.gsub!(/[\n]/,' ')

  answ = answ[answ.index(str2), answ.index(str3)]
  answ = answ[answ.index(str2), answ.index(str3)]
  answ.gsub!(str2,' ')

  answ = answ.lstrip

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
