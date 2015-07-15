class QuizController < ApplicationController

TOKEN = '34291703b59f5c7e827d31116f0bf161'.freeze

  def index


    render nothing: true

  if params[:level] == 1
  @question=params[:question]
  @id = params[:id]
  results = Poem.content(@question)
  uri = URI("http://pushkin-contest.ror.by/quiz")
  parameters = {
    answer: results.first.title,
    token: TOKEN,
    task_id:  @id
  }
  Net::HTTP.post_form(uri, parameters)
  end

  end
end
