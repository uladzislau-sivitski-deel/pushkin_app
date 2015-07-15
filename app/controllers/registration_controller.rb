class RegistrationController < ApplicationController
skip_before_filter :verify_authenticity_token, :only => [:index]

  def index

 #   @question = params[:question]
  #  str1 = @question.gsub('%WORD%','')
  #  str2 = @question.split('%WORD%')[0]
   # str3 = @question.split('%WORD%')[1]
   # result = Poem.search do
    #  fulltext str1 do
   #   query_phrase_slop 1
   # end
 # end
   # answer = result.results[0].content
  #  answer.gsub!(/[\n]/,' ')
   # answer = answer[answer.index(str2),answer.index(str3)]
   # answer.gsub!(str2,' ')

    render json: {answer: 'снежные'}

end
end
