class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]
  attr_accessor :name, :grade
  attr_reader :id


  def initialize(name, grade, id=nil)
    @name = name
    @grade = grade
    @id = nil
  end

  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS students
        (id INTEGER PRIMARY KEY,
        name TEXT,
        grade INTEGER)
    SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
    DB[:conn].execute("DROP TABLE students")
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL
    DB[:conn].execute(sql, self.name, self.grade)

    sql = <<-SQL
      SELECT id
      FROM students
      ORDER BY id LIMIT 1
    SQL
    @id = DB[:conn].execute(sql)[0][0]
  end

  def self.create(student_hash)
    new_student = Student.new(student_hash[:name], student_hash[:grade])
    new_student.save
    new_student
  end

end
