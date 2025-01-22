class FormAnswersController < ApplicationController
    before_action :set_category
    before_action :set_form_question
  
    def create
      @form_answer = @form_question.form_answers.build(answer_params)
      if @form_answer.save
        render json: { success: true, id: @form_answer.id }
      else
        render json: { success: false, error: @form_answer.errors.full_messages.join(", ") }
      end
    end
  
    def update
      @form_answer = @form_question.form_answers.find(params[:id])
      if @form_answer.update(answer_params)
        render json: { success: true }
      else
        render json: { success: false, error: @form_answer.errors.full_messages.join(", ") }
      end
    end
  
    def destroy
      @form_answer = @form_question.form_answers.find(params[:id])
      if @form_answer.destroy
        render json: { success: true }
      else
        render json: { success: false, error: "Failed to delete answer" }
      end
    end
  
    private
  
    def set_category
      @category = Category.find(params[:category_id])
    end
  
    def set_form_question
      @form_question = @category.form_questions.find(params[:form_question_id])
    end
  
    def answer_params
      params.require(:form_answer).permit(:answer)
    end
  end