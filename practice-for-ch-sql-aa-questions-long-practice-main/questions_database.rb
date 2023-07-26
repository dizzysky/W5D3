require 'sqlite3'
require 'singleton'



class QuestionsDatabase < SQLite3::Database
    include Singleton

    def initialize
        super('questions.db')
        self.type_translation = true
        self.results_as_hash = true
    end
end



class Question 

    attr_accessor :id, :title, :body, :author_id

    def self.find_by_id(id)
        question = QuestionsDatabase.instance.execute(<<-SQL, id)
            SELECT
                * 
            FROM
                questions
            WHERE
                id = ?
        SQL
        return nil unless question.length > 0
        Question.new(question.first)
    end


    def initialize(options)
        @id = options['id']
        @title = options['title']
        @body = options['body']
        @author_id = options['author_id']
    end



end



class User

    attr_accessor :id, :fname, :lname


    def self.find_by_name(fname, lname)
        person = QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
            SELECT
                *
            FROM
                users

            WHERE
                fname = ?
                AND lname = ?
        SQL
        return nil unless person.length > 0
        User.new(person.first)
    end


    def initialize(options)
        @id = options['id']
        @fname = options['fname']
        @lname = options['lname']
    end




end



class QuestionFollows


    attr_accessor :id, :user_id, :question_id


    def find_by_id(id)
        question_follow = QuestionsDatabase.instance.execute(<<-SQL, id)
        SELECT
            * 
        FROM 
            question_follows
        WHERE
            id = ?
        SQL

        return nil unless question_follows.length > 0
        QuestionFollows.new(question_follow.first)
    end

    def initialize(options)
        @id = options['id']
        @user_id = options['user_id']
        @question_id = options['question_id']
    end

end