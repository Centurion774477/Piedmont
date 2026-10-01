# frozen_string_literal: true

class GradingController < ApplicationController
  def grade
    if params[:answer_key].blank?
      redirect_to root_path
      flash[:error] = "Please provide an answer key."
      return
    end

    if params[:student_answers].blank?
      redirect_to root_path
      flash[:error] = "Please provide the student's answers."
      return
    end

    if params[:answer_key].nil? || params[:student_answers].nil?
      redirect_to root_path
      return
    end

    @result = process_data params[:answer_key], params[:student_answers]
  end

  private

  def process_data(answer_key, student_answers)
    answer_words = answer_key.split
    student_words = student_answers.split

    output = {
      score: 0,
      wrong_answers: [],
      total_length: answer_words.length
    }

    answer_words.zip(student_words).each do |word, student_word|
      next if word.blank? || student_word.blank?

      if word.strip == student_word.strip
        output[:score] += 1
        next
      else
        hash = {
          correct: word,
          incorrect: student_word
        }
        output[:wrong_answers] << hash
      end
    end

    return output
  end
end
