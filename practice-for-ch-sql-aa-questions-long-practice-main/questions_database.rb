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



    def self.find_by_author_id(author_id)
        question_rows = QuestionsDatabase.instance.execute(<<-SQL, author_id)

        SELECT 
            *
        FROM
            questions
        WHERE
            author_id = ?
        SQL


        question_rows.map { |question| Question.new(question)}
    end

    def author
        
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

    def authored_questions
        Question.find_by_author_id(id)
    end

    def authored_replies
        Replies.find_by_user_id(id)
    end
end



class QuestionFollows


    attr_accessor :id, :user_id, :question_id


    def self.find_by_id(id)
        question_follow = QuestionsDatabase.instance.execute(<<-SQL, id)
        SELECT
            * 
        FROM 
            question_follows
        WHERE
            id = ?
        SQL

        return nil unless question_follow.length > 0
        QuestionFollows.new(question_follow.first)
    end

    def initialize(options)
        @id = options['id']
        @user_id = options['user_id']
        @question_id = options['question_id']
    end

end

class Replies
    attr_accessor :id, :question_id, :parent_reply_id, :author_id, :body

    def self.find_by_id(id)
        reply = QuestionsDatabase.instance.execute(<<-SQL, id)
            SELECT
                *
            FROM
                replies
            WHERE
                id = ?
        SQL
        return nil unless reply.length > 0

        Replies.new(reply.first)
    end



    def self.find_by_user_id(author_id)
        reply_rows = QuestionsDatabase.instance.execute(<<-SQL, author_id)

        SELECT 
            *
        FROM
            replies
        WHERE
            author_id = ?
        SQL


        reply_rows.map { |reply| Replies.new(reply)}
    end

    def self.find_by_question_id(question_id)
        reply_rows = QuestionsDatabase.instance.execute(<<-SQL, question_id)
            SELECT
                *
            FROM
                replies
            WHERE
                question_id = ?
        SQL

        reply_rows.map { |reply| Replies.new(reply) }
    end

    def initialize(options)
        @id = options['id']
        @question_id = options['question_id']
        @parent_reply_id = options['parent_reply_id']
        @author_id = options['author_id']
        @body = options['body']
    end
end

class QuestionLikes
    attr_accessor :id, :user_id, :question_id

    def self.find_by_id(id)
        question_like = QuestionsDatabase.instance.execute(<<-SQL, id)
            SELECT
                *
            FROM
                question_likes
            WHERE
                id = ?
        SQL
        return nil unless question_like.length > 0

        QuestionLikes.new(question_like.first)
    end

    def initialize(options)
        @id = options['id']
        @user_id = options['user_id']
        @question_id = options['question_id']
    end
end