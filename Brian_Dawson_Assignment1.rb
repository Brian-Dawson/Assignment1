
#Project name: Assignment #1
#Description: Create a program that takes in two inputs files, one for students and one for courses and places students into their desired courses.
# It then outputs this information into two output files, one for students and one for courses.
#Filename: Brian_Dawson_Assignment_1.rb
#Description: This is the main file for the program
#Last modified on: 9/13/19

# The code is broken into 7 main components
#
# The first is the Class Classes which takes in all of the necessary information from each course from the input file and save them for use in the program
# The class has both getters and setter and acts as a way to compartmentalize each individual couse
#
# The second component is the Class Students which is very similar to Classes as it also takes in all of the necessary information and then compartmentalizes the courses
#
# The third component is the input section which takes in the two input files for the program and then using the smarter_csv gem puts them into hashes for use later.
# This component also holds the gems used in the program.
#
# The fourth component is the creation of the various different student and courses objects from the input hashes
# This data is then transfered into two arrays for easier access and use later in the program
#
# The fifth component is the first run through of the main algorithm
# It costs of two main while loops where the courses loop is nested within the student loop
# This enable the program to run through each courses for each of the students
# The course then performs a variety of checks to make sure the input data is correct and to correctly match the students to their preferences
# The data is then updated for the student and the courses
#
# The sixth component is the second run through of the algorithm for students who request a second course
# This part is very similar to the first algorithm and performs largely the same checks
# The only addition is another check to see if the student even wants a second course
#
# The seventh component is the output of the data into the output files
# This component collects all of the data and then using loops outputs the correct data into the correct files


#-----------------------------------------------------------------------------------------
#
# Classes
#
#Classes is a class that is created to hold all of the courses available to the students
# For each new course, it creates a Classes object that holds all of the necessary information for the course
#-----------------------------------------------------------------------------------------

class Classes
  def initialize(course, sections, minimum_seats, maximum_seats, requirements) #Initializes and takes in all of the information from the input files
    @course = course #Name of the course
    @sections = sections #Number of sections
    @minimum_seats = minimum_seats
    @maximum_seats = maximum_seats
    @requirements = requirements
    @students_enrolled = 0 #The number of students enrolled in this course
    @student_ids = Array.new #An array of the student's id's in the order that they were put in the course
    @seats_filled = 0
    @sections_filled = 0
    @true_max_seats = @maximum_seats * @sections #Max seats in the whole course over all sections
    @seats_open = @true_max_seats
  end
  #Creation of the different getter and setter methods required for use later in the program
  def max_seats_call
    return @true_max_seats
  end
  def course_call
    return @course
  end
  def sections_call
    return @sections
  end
  def minimum_seats_call
    return @minimum_seats
  end
  def maximum_seats_call
    return @maximum_seats
  end
  def requirements_call
    return @requirements
  end
  def students_enrolled_call
    return @students_enrolled
  end
  def students_enrolled_ids_push(id) #Takes in student id's and then adds them to the array
    @student_ids[@students_enrolled] = id
    @students_enrolled += 1 #Also adds one student to the number enrolled
    @seats_open -= 1 #Decrements seats open
    @seats_filled += 1 #Increments seats filled
  end
  def student_ids_call
    return @student_ids
  end
  def seats_open_call
    return @seats_open
  end
  def seats_filled_call
    return @seats_filled
  end
  def student_ids_output #Outputs the student id's array in the form of a string
    return (@student_ids).join(', ')
  end
end

#-----------------------------------------------------------------------------------------
#
# Students
#
#Students is a class that is created to create Students objects which hold all of the information on each student and keeps each student compartmentalized
#-----------------------------------------------------------------------------------------

class Students
  def initialize(paws_id, number_of_courses, choice1, choice2, choice3, choice4, choice5) #Initializses the Students objects and takes in all of the information from the input file
    @paws_id = paws_id #ID value of the student
    @number_of_courses_wanted = number_of_courses
    @choice1 = choice1
    @choice2 = choice2
    @choice3 = choice3
    @choice4 = choice4
    @choice5 = choice5
    @enrollment_errors = Array.new #An array that holds any errors that may happen during registration
    @enrollment_errors_counter = 0 #Counter for errors
    @courses_enrolled = Array.new #An array that holds the courses that they are enrolled in
    @course_enrollment_counter = 0
  end
  #Definining the getter and setter methods required for the running of the program
  def number_of_courses
    return @number_of_courses_wanted
  end
  def course_enrollment_counter_call
    return @course_enrollment_counter
  end
  def courses_enrolled_call
    return @courses_enrolled
  end
  def courses_enrolled_final #The final output used for outputting to the files. Converts the array to a string
    return @courses_enrolled.join(', ')
  end
  def id_call
    return @paws_id
  end
  def number_courses_call
    return @number_of_courses_wanted
  end
  def choice1_call
    return @choice1
  end
  def choice2_call
    return @choice2
  end
  def choice3_call
    return @choice3
  end
  def choice4_call
    return @choice4
  end
  def choice5_call
    return @choice5
  end
  def course_enrollments(course) #Setter used when a student is enrolled in a class
    @courses_enrolled[@course_enrollment_counter] = course #Takes in the course and puts the course into the array for that student
    @course_enrollment_counter += 1 #Increments the counter for the student
  end
  def enrollment_errors(error) #Setter used to input any errors that occured during enrollment into an array
      @enrollment_errors[@enrollment_errors_counter] = error
    @enrollment_errors_counter += 1 #Increments the error counter by 1
  end
  def enrollment_errors_call
    return @enrollment_errors
  end
  def enrollment_errors_final #Outputs the errors for the output file in the form of a string
    return @enrollment_errors.join(', ')
  end
end


  #Main part of program including input, output, data structures, etc.


  #Input part of program
 #Includes gems and inputs of files

  require 'smarter_csv'
  require 'csv'

      puts "Welcome to the registration program"
      puts "Please enter the correct file path for your course constraints file"
      course_constraints_initial = gets.strip
       if (File.file?(course_constraints_initial) == true)
      course_constraints_hash = SmarterCSV.process(course_constraints_initial)
       else
       puts "Please restart and enter the correct file name"
      end


      puts "Please enter the correct path the student preferences files"
      student_prefs_initial = gets.strip
      if (File.file?(student_prefs_initial) == true)
      student_prefs_hash = SmarterCSV.process(student_prefs_initial)
       else
       puts "Please restart and enter the correct file name"
       end



  student_prefs_length = student_prefs_hash.length
  course_constraints_length = course_constraints_hash.length

  #Conversion of input into data structures
 #Each index of student array contains a Students object containing all of the information about that student

  student_array = []
  c = 0
  while c < student_prefs_length
    student_array[c] = Students.new(student_prefs_hash[c][:paws_id], student_prefs_hash[c][:number_of_courses], student_prefs_hash[c][:first_choice], student_prefs_hash[c][:second_choice], student_prefs_hash[c][:third_choice], student_prefs_hash[c][:fourth_choice], student_prefs_hash[c][:fifth_choice])
    c+=1
  end

#Each index of course array contains a Classes object containing all of the information about that course

  course_array = []
  i = 0
  while i < course_constraints_length
  course_array[i] = Classes.new(course_constraints_hash[i][:course], course_constraints_hash[i][:sections], course_constraints_hash[i][:minimum_seats], course_constraints_hash[i][:maximum_seats], course_constraints_hash[i][:requirements])
    i+=1
  end


  #Algorithm part of program
      # # First Run through of Students + Classes
# The core of the algorithm is that for each student all of the courses are checked against their preferences and if a match is found the student is then placed into the courses and the necessary information is updated
# There are checks for edges cases and mistakes
      a = 0
      while a < student_array.length
        b = 0
        while b < course_array.length
          if(not(student_array[a].choice1_call.nil?)) and (not(student_array[a].choice2_call.nil?)) and (not(student_array[a].choice3_call.nil?)) and (not(student_array[a].choice4_call.nil?)) and (not(student_array[a].choice5_call.nil?))
            if((not(student_array[a].choice1_call.include?(":N") and (student_array[a].choice1_call.include?(":Y")))) and (student_array[a].choice1_call.delete(' ') == course_array[b].course_call.delete(' ')) and (course_array[b].seats_filled_call < course_array[b].max_seats_call) and (student_array[a].number_courses_call > 0) and (course_array[b].sections_call > 0) and (student_array[a].course_enrollment_counter_call < 1)) or (student_array[a].choice1_call.delete(' ') == course_array[b].course_call.delete(' ') + ":Y") and (course_array[b].seats_filled_call < course_array[b].max_seats_call) and (student_array[a].number_courses_call > 0) and (course_array[b].sections_call > 0) and (student_array[a].course_enrollment_counter_call < 1)
                student_array[a].course_enrollments(course_array[b].course_call.delete(' ')) and course_array[b].students_enrolled_ids_push(student_array[a].id_call)
          elsif((not(student_array[a].choice2_call.include?(":N") and (student_array[a].choice2_call.include?(":Y")))) and (student_array[a].choice2_call.delete(' ') == course_array[b].course_call.delete(' ')) and (course_array[b].seats_filled_call < course_array[b].max_seats_call) and (student_array[a].number_courses_call > 0) and (course_array[b].sections_call > 0) and (student_array[a].course_enrollment_counter_call < 1)) or (student_array[a].choice2_call.delete(' ') == course_array[b].course_call.delete(' ') + ":Y") and (course_array[b].seats_filled_call < course_array[b].max_seats_call) and (student_array[a].number_courses_call > 0) and (course_array[b].sections_call > 0) and (student_array[a].course_enrollment_counter_call < 1)
            student_array[a].course_enrollments(course_array[b].course_call.delete(' ')) and course_array[b].students_enrolled_ids_push(student_array[a].id_call)
          elsif((not(student_array[a].choice3_call.include?(":N") and (student_array[a].choice3_call.include?(":Y")))) and (student_array[a].choice3_call.delete(' ') == course_array[b].course_call.delete(' ')) and (course_array[b].seats_filled_call < course_array[b].max_seats_call) and (student_array[a].number_courses_call > 0) and (course_array[b].sections_call > 0) and (student_array[a].course_enrollment_counter_call < 1)) or (student_array[a].choice3_call.delete(' ') == course_array[b].course_call.delete(' ') + ":Y") and (course_array[b].seats_filled_call < course_array[b].max_seats_call) and (student_array[a].number_courses_call > 0) and (course_array[b].sections_call > 0) and (student_array[a].course_enrollment_counter_call < 1)
            student_array[a].course_enrollments(course_array[b].course_call.delete(' ')) and course_array[b].students_enrolled_ids_push(student_array[a].id_call)
          elsif((not(student_array[a].choice4_call.include?(":N") and (student_array[a].choice4_call.include?(":Y")))) and (student_array[a].choice4_call.delete(' ') == course_array[b].course_call.delete(' ')) and (course_array[b].seats_filled_call < course_array[b].max_seats_call) and (student_array[a].number_courses_call > 0) and (course_array[b].sections_call > 0) and (student_array[a].course_enrollment_counter_call < 1)) or (student_array[a].choice4_call.delete(' ') == course_array[b].course_call.delete(' ') + ":Y") and (course_array[b].seats_filled_call < course_array[b].max_seats_call) and (student_array[a].number_courses_call > 0) and (course_array[b].sections_call > 0) and (student_array[a].course_enrollment_counter_call < 1)
            student_array[a].course_enrollments(course_array[b].course_call.delete(' ')) and course_array[b].students_enrolled_ids_push(student_array[a].id_call)
          elsif((not(student_array[a].choice5_call.include?(":N") and (student_array[a].choice5_call.include?(":Y")))) and (student_array[a].choice5_call.delete(' ') == course_array[b].course_call.delete(' ')) and (course_array[b].seats_filled_call < course_array[b].max_seats_call) and (student_array[a].number_courses_call > 0) and (course_array[b].sections_call > 0) and (student_array[a].course_enrollment_counter_call < 1)) or (student_array[a].choice5_call.delete(' ') == course_array[b].course_call.delete(' ') + ":Y") and (course_array[b].seats_filled_call < course_array[b].max_seats_call) and (student_array[a].number_courses_call > 0) and (course_array[b].sections_call > 0) and (student_array[a].course_enrollment_counter_call < 1)
            student_array[a].course_enrollments(course_array[b].course_call.delete(' ')) and course_array[b].students_enrolled_ids_push(student_array[a].id_call)
            end
          elsif(not(student_array[a].choice1_call.nil?)) and (not(student_array[a].choice2_call.nil?)) and (not(student_array[a].choice3_call.nil?)) and (not(student_array[a].choice4_call.nil?))
            if((not(student_array[a].choice1_call.include?(":N") and (student_array[a].choice1_call.include?(":Y")))) and (student_array[a].choice1_call.delete(' ') == course_array[b].course_call.delete(' ')) and (course_array[b].seats_filled_call < course_array[b].max_seats_call) and (student_array[a].number_courses_call > 0) and (course_array[b].sections_call > 0) and (student_array[a].course_enrollment_counter_call < 1)) or (student_array[a].choice1_call.delete(' ') == course_array[b].course_call.delete(' ') + ":Y") and (course_array[b].seats_filled_call < course_array[b].max_seats_call) and (student_array[a].number_courses_call > 0) and (course_array[b].sections_call > 0) and (student_array[a].course_enrollment_counter_call < 1)
              student_array[a].course_enrollments(course_array[b].course_call.delete(' ')) and course_array[b].students_enrolled_ids_push(student_array[a].id_call)
            elsif((not(student_array[a].choice2_call.include?(":N") and (student_array[a].choice2_call.include?(":Y")))) and (student_array[a].choice2_call.delete(' ') == course_array[b].course_call.delete(' ')) and (course_array[b].seats_filled_call < course_array[b].max_seats_call) and (student_array[a].number_courses_call > 0) and (course_array[b].sections_call > 0) and (student_array[a].course_enrollment_counter_call < 1)) or (student_array[a].choice2_call.delete(' ') == course_array[b].course_call.delete(' ') + ":Y") and (course_array[b].seats_filled_call < course_array[b].max_seats_call) and (student_array[a].number_courses_call > 0) and (course_array[b].sections_call > 0) and (student_array[a].course_enrollment_counter_call < 1)
              student_array[a].course_enrollments(course_array[b].course_call.delete(' ')) and course_array[b].students_enrolled_ids_push(student_array[a].id_call)
            elsif((not(student_array[a].choice3_call.include?(":N") and (student_array[a].choice3_call.include?(":Y")))) and (student_array[a].choice3_call.delete(' ') == course_array[b].course_call.delete(' ')) and (course_array[b].seats_filled_call < course_array[b].max_seats_call) and (student_array[a].number_courses_call > 0) and (course_array[b].sections_call > 0) and (student_array[a].course_enrollment_counter_call < 1)) or (student_array[a].choice3_call.delete(' ') == course_array[b].course_call.delete(' ') + ":Y") and (course_array[b].seats_filled_call < course_array[b].max_seats_call) and (student_array[a].number_courses_call > 0) and (course_array[b].sections_call > 0) and (student_array[a].course_enrollment_counter_call < 1)
              student_array[a].course_enrollments(course_array[b].course_call.delete(' ')) and course_array[b].students_enrolled_ids_push(student_array[a].id_call)
            elsif((not(student_array[a].choice4_call.include?(":N") and (student_array[a].choice4_call.include?(":Y")))) and (student_array[a].choice4_call.delete(' ') == course_array[b].course_call.delete(' ')) and (course_array[b].seats_filled_call < course_array[b].max_seats_call) and (student_array[a].number_courses_call > 0) and (course_array[b].sections_call > 0) and (student_array[a].course_enrollment_counter_call < 1)) or (student_array[a].choice4_call.delete(' ') == course_array[b].course_call.delete(' ') + ":Y") and (course_array[b].seats_filled_call < course_array[b].max_seats_call) and (student_array[a].number_courses_call > 0) and (course_array[b].sections_call > 0) and (student_array[a].course_enrollment_counter_call < 1)
              student_array[a].course_enrollments(course_array[b].course_call.delete(' ')) and course_array[b].students_enrolled_ids_push(student_array[a].id_call)
              end
          elsif(not(student_array[a].choice1_call.nil?)) and (not(student_array[a].choice2_call.nil?)) and (not(student_array[a].choice3_call.nil?))
            if((not(student_array[a].choice1_call.include?(":N") and (student_array[a].choice1_call.include?(":Y")))) and (student_array[a].choice1_call.delete(' ') == course_array[b].course_call.delete(' ')) and (course_array[b].seats_filled_call < course_array[b].max_seats_call) and (student_array[a].number_courses_call > 0) and (course_array[b].sections_call > 0) and (student_array[a].course_enrollment_counter_call < 1)) or (student_array[a].choice1_call.delete(' ') == course_array[b].course_call.delete(' ') + ":Y") and (course_array[b].seats_filled_call < course_array[b].max_seats_call) and (student_array[a].number_courses_call > 0) and (course_array[b].sections_call > 0) and (student_array[a].course_enrollment_counter_call < 1)
              student_array[a].course_enrollments(course_array[b].course_call.delete(' ')) and course_array[b].students_enrolled_ids_push(student_array[a].id_call)
            elsif((not(student_array[a].choice2_call.include?(":N") and (student_array[a].choice2_call.include?(":Y")))) and (student_array[a].choice2_call.delete(' ') == course_array[b].course_call.delete(' ')) and (course_array[b].seats_filled_call < course_array[b].max_seats_call) and (student_array[a].number_courses_call > 0) and (course_array[b].sections_call > 0) and (student_array[a].course_enrollment_counter_call < 1)) or (student_array[a].choice2_call.delete(' ') == course_array[b].course_call.delete(' ') + ":Y") and (course_array[b].seats_filled_call < course_array[b].max_seats_call) and (student_array[a].number_courses_call > 0) and (course_array[b].sections_call > 0) and (student_array[a].course_enrollment_counter_call < 1)
              student_array[a].course_enrollments(course_array[b].course_call.delete(' ')) and course_array[b].students_enrolled_ids_push(student_array[a].id_call)
            elsif((not(student_array[a].choice3_call.include?(":N") and (student_array[a].choice3_call.include?(":Y")))) and (student_array[a].choice3_call.delete(' ') == course_array[b].course_call.delete(' ')) and (course_array[b].seats_filled_call < course_array[b].max_seats_call) and (student_array[a].number_courses_call > 0) and (course_array[b].sections_call > 0) and (student_array[a].course_enrollment_counter_call < 1)) or (student_array[a].choice3_call.delete(' ') == course_array[b].course_call.delete(' ') + ":Y") and (course_array[b].seats_filled_call < course_array[b].max_seats_call) and (student_array[a].number_courses_call > 0) and (course_array[b].sections_call > 0) and (student_array[a].course_enrollment_counter_call < 1)
              student_array[a].course_enrollments(course_array[b].course_call.delete(' ')) and course_array[b].students_enrolled_ids_push(student_array[a].id_call)
            end
          elsif(not(student_array[a].choice1_call.nil?)) and (not(student_array[a].choice2_call.nil?))
            if((not(student_array[a].choice1_call.include?(":N") and (student_array[a].choice1_call.include?(":Y")))) and (student_array[a].choice1_call.delete(' ') == course_array[b].course_call.delete(' ')) and (course_array[b].seats_filled_call < course_array[b].max_seats_call) and (student_array[a].number_courses_call > 0) and (course_array[b].sections_call > 0) and (student_array[a].course_enrollment_counter_call < 1)) or (student_array[a].choice1_call.delete(' ') == course_array[b].course_call.delete(' ') + ":Y") and (course_array[b].seats_filled_call < course_array[b].max_seats_call) and (student_array[a].number_courses_call > 0) and (course_array[b].sections_call > 0) and (student_array[a].course_enrollment_counter_call < 1)
              student_array[a].course_enrollments(course_array[b].course_call.delete(' ')) and course_array[b].students_enrolled_ids_push(student_array[a].id_call)
            elsif((not(student_array[a].choice2_call.include?(":N") and (student_array[a].choice2_call.include?(":Y")))) and (student_array[a].choice2_call.delete(' ') == course_array[b].course_call.delete(' ')) and (course_array[b].seats_filled_call < course_array[b].max_seats_call) and (student_array[a].number_courses_call > 0) and (course_array[b].sections_call > 0) and (student_array[a].course_enrollment_counter_call < 1)) or (student_array[a].choice2_call.delete(' ') == course_array[b].course_call.delete(' ') + ":Y") and (course_array[b].seats_filled_call < course_array[b].max_seats_call) and (student_array[a].number_courses_call > 0) and (course_array[b].sections_call > 0) and (student_array[a].course_enrollment_counter_call < 1)
              student_array[a].course_enrollments(course_array[b].course_call.delete(' ')) and course_array[b].students_enrolled_ids_push(student_array[a].id_call)
            end
          elsif(not(student_array[a].choice1_call.nil?))
            if((not(student_array[a].choice1_call.include?(":N") and (student_array[a].choice1_call.include?(":Y")))) and (student_array[a].choice1_call.delete(' ') == course_array[b].course_call.delete(' ')) and (course_array[b].seats_filled_call < course_array[b].max_seats_call) and (student_array[a].number_courses_call > 0) and (course_array[b].sections_call > 0) and (student_array[a].course_enrollment_counter_call < 1)) or (student_array[a].choice1_call.delete(' ') == course_array[b].course_call.delete(' ') + ":Y") and (course_array[b].seats_filled_call < course_array[b].max_seats_call) and (student_array[a].number_courses_call > 0) and (course_array[b].sections_call > 0) and (student_array[a].course_enrollment_counter_call < 1)
              student_array[a].course_enrollments(course_array[b].course_call.delete(' ')) and course_array[b].students_enrolled_ids_push(student_array[a].id_call)
            end
            end
          b += 1
        end
        if(student_array[a].course_enrollment_counter_call == 0)
          student_array[a].enrollment_errors("All of the students preferences are closed")
        end
        a += 1
        end

  #Second run through if students want a second class
# This part of the algorithm is very similar to the first part except it only runs if the student has shown an interest in having a second course
c = 0
while c < student_array.length
  if (student_array[c].number_of_courses == 2)
  d = 0
  while d < course_array.length
    if(not(student_array[c].choice1_call.nil?)) and (not(student_array[c].choice2_call.nil?)) and (not(student_array[c].choice3_call.nil?)) and (not(student_array[c].choice4_call.nil?)) and (not(student_array[c].choice5_call.nil?))
      if((not(student_array[c].choice1_call.include?(":N") and (student_array[c].choice1_call.include?(":Y")))) and (student_array[c].choice1_call.delete(' ') == course_array[d].course_call.delete(' ')) and (course_array[d].seats_filled_call < course_array[d].max_seats_call) and (student_array[c].number_courses_call > 0) and (course_array[d].sections_call > 0) and (student_array[c].course_enrollment_counter_call < 1)) or (student_array[c].choice1_call.delete(' ') == course_array[d].course_call.delete(' ') + ":Y") and (course_array[d].seats_filled_call < course_array[d].max_seats_call) and (student_array[c].number_courses_call > 0) and (course_array[d].sections_call > 0) and (student_array[c].course_enrollment_counter_call < 2)
        student_array[c].course_enrollments(course_array[d].course_call.delete(' ')) and course_array[d].students_enrolled_ids_push(student_array[c].id_call)
      elsif((not(student_array[c].choice2_call.include?(":N") and (student_array[c].choice2_call.include?(":Y")))) and (student_array[c].choice2_call.delete(' ') == course_array[d].course_call.delete(' ')) and (course_array[d].seats_filled_call < course_array[d].max_seats_call) and (student_array[c].number_courses_call > 0) and (course_array[d].sections_call > 0) and (student_array[c].course_enrollment_counter_call < 1)) or (student_array[c].choice2_call.delete(' ') == course_array[d].course_call.delete(' ') + ":Y") and (course_array[d].seats_filled_call < course_array[d].max_seats_call) and (student_array[c].number_courses_call > 0) and (course_array[d].sections_call > 0) and (student_array[c].course_enrollment_counter_call < 2)
        student_array[c].course_enrollments(course_array[d].course_call.delete(' ')) and course_array[d].students_enrolled_ids_push(student_array[c].id_call)
      elsif((not(student_array[c].choice3_call.include?(":N") and (student_array[c].choice3_call.include?(":Y")))) and (student_array[c].choice3_call.delete(' ') == course_array[d].course_call.delete(' ')) and (course_array[d].seats_filled_call < course_array[d].max_seats_call) and (student_array[c].number_courses_call > 0) and (course_array[d].sections_call > 0) and (student_array[c].course_enrollment_counter_call < 1)) or (student_array[c].choice3_call.delete(' ') == course_array[d].course_call.delete(' ') + ":Y") and (course_array[d].seats_filled_call < course_array[d].max_seats_call) and (student_array[c].number_courses_call > 0) and (course_array[d].sections_call > 0) and (student_array[c].course_enrollment_counter_call < 2)
        student_array[c].course_enrollments(course_array[d].course_call.delete(' ')) and course_array[d].students_enrolled_ids_push(student_array[c].id_call)
      elsif((not(student_array[c].choice4_call.include?(":N") and (student_array[c].choice4_call.include?(":Y")))) and (student_array[c].choice4_call.delete(' ') == course_array[d].course_call.delete(' ')) and (course_array[d].seats_filled_call < course_array[d].max_seats_call) and (student_array[c].number_courses_call > 0) and (course_array[d].sections_call > 0) and (student_array[c].course_enrollment_counter_call < 1)) or (student_array[c].choice4_call.delete(' ') == course_array[d].course_call.delete(' ') + ":Y") and (course_array[d].seats_filled_call < course_array[d].max_seats_call) and (student_array[c].number_courses_call > 0) and (course_array[d].sections_call > 0) and (student_array[c].course_enrollment_counter_call < 2)
        student_array[c].course_enrollments(course_array[d].course_call.delete(' ')) and course_array[d].students_enrolled_ids_push(student_array[c].id_call)
      elsif((not(student_array[c].choice5_call.include?(":N") and (student_array[c].choice5_call.include?(":Y")))) and (student_array[c].choice5_call.delete(' ') == course_array[d].course_call.delete(' ')) and (course_array[d].seats_filled_call < course_array[d].max_seats_call) and (student_array[c].number_courses_call > 0) and (course_array[d].sections_call > 0) and (student_array[c].course_enrollment_counter_call < 1)) or (student_array[c].choice5_call.delete(' ') == course_array[d].course_call.delete(' ') + ":Y") and (course_array[d].seats_filled_call < course_array[d].max_seats_call) and (student_array[c].number_courses_call > 0) and (course_array[d].sections_call > 0) and (student_array[c].course_enrollment_counter_call < 2)
        student_array[c].course_enrollments(course_array[d].course_call.delete(' ')) and course_array[d].students_enrolled_ids_push(student_array[c].id_call)
      end
    elsif(not(student_array[c].choice1_call.nil?)) and (not(student_array[c].choice2_call.nil?)) and (not(student_array[c].choice3_call.nil?)) and (not(student_array[c].choice4_call.nil?))
      if((not(student_array[c].choice1_call.include?(":N") and (student_array[c].choice1_call.include?(":Y")))) and (student_array[c].choice1_call.delete(' ') == course_array[d].course_call.delete(' ')) and (course_array[d].seats_filled_call < course_array[d].max_seats_call) and (student_array[c].number_courses_call > 0) and (course_array[d].sections_call > 0) and (student_array[c].course_enrollment_counter_call < 1)) or (student_array[c].choice1_call.delete(' ') == course_array[d].course_call.delete(' ') + ":Y") and (course_array[d].seats_filled_call < course_array[d].max_seats_call) and (student_array[c].number_courses_call > 0) and (course_array[d].sections_call > 0) and (student_array[c].course_enrollment_counter_call < 2)
        student_array[c].course_enrollments(course_array[d].course_call.delete(' ')) and course_array[d].students_enrolled_ids_push(student_array[c].id_call)
      elsif((not(student_array[c].choice2_call.include?(":N") and (student_array[c].choice2_call.include?(":Y")))) and (student_array[c].choice2_call.delete(' ') == course_array[d].course_call.delete(' ')) and (course_array[d].seats_filled_call < course_array[d].max_seats_call) and (student_array[c].number_courses_call > 0) and (course_array[d].sections_call > 0) and (student_array[c].course_enrollment_counter_call < 1)) or (student_array[c].choice2_call.delete(' ') == course_array[d].course_call.delete(' ') + ":Y") and (course_array[d].seats_filled_call < course_array[d].max_seats_call) and (student_array[c].number_courses_call > 0) and (course_array[d].sections_call > 0) and (student_array[c].course_enrollment_counter_call < 2)
        student_array[c].course_enrollments(course_array[d].course_call.delete(' ')) and course_array[d].students_enrolled_ids_push(student_array[c].id_call)
      elsif((not(student_array[c].choice3_call.include?(":N") and (student_array[c].choice3_call.include?(":Y")))) and (student_array[c].choice3_call.delete(' ') == course_array[d].course_call.delete(' ')) and (course_array[d].seats_filled_call < course_array[d].max_seats_call) and (student_array[c].number_courses_call > 0) and (course_array[d].sections_call > 0) and (student_array[c].course_enrollment_counter_call < 1)) or (student_array[c].choice3_call.delete(' ') == course_array[d].course_call.delete(' ') + ":Y") and (course_array[d].seats_filled_call < course_array[d].max_seats_call) and (student_array[c].number_courses_call > 0) and (course_array[d].sections_call > 0) and (student_array[c].course_enrollment_counter_call < 2)
        student_array[c].course_enrollments(course_array[d].course_call.delete(' ')) and course_array[d].students_enrolled_ids_push(student_array[c].id_call)
      elsif((not(student_array[c].choice4_call.include?(":N") and (student_array[c].choice4_call.include?(":Y")))) and (student_array[c].choice4_call.delete(' ') == course_array[d].course_call.delete(' ')) and (course_array[d].seats_filled_call < course_array[d].max_seats_call) and (student_array[c].number_courses_call > 0) and (course_array[d].sections_call > 0) and (student_array[c].course_enrollment_counter_call < 1)) or (student_array[c].choice4_call.delete(' ') == course_array[d].course_call.delete(' ') + ":Y") and (course_array[d].seats_filled_call < course_array[d].max_seats_call) and (student_array[c].number_courses_call > 0) and (course_array[d].sections_call > 0) and (student_array[c].course_enrollment_counter_call < 2)
        student_array[c].course_enrollments(course_array[d].course_call.delete(' ')) and course_array[d].students_enrolled_ids_push(student_array[c].id_call)
      end
    elsif(not(student_array[c].choice1_call.nil?)) and (not(student_array[c].choice2_call.nil?)) and (not(student_array[c].choice3_call.nil?))
      if((not(student_array[c].choice1_call.include?(":N") and (student_array[c].choice1_call.include?(":Y")))) and (student_array[c].choice1_call.delete(' ') == course_array[d].course_call.delete(' ')) and (course_array[d].seats_filled_call < course_array[d].max_seats_call) and (student_array[c].number_courses_call > 0) and (course_array[d].sections_call > 0) and (student_array[c].course_enrollment_counter_call < 1)) or (student_array[c].choice1_call.delete(' ') == course_array[d].course_call.delete(' ') + ":Y") and (course_array[d].seats_filled_call < course_array[d].max_seats_call) and (student_array[c].number_courses_call > 0) and (course_array[d].sections_call > 0) and (student_array[c].course_enrollment_counter_call < 2)
        student_array[c].course_enrollments(course_array[d].course_call.delete(' ')) and course_array[d].students_enrolled_ids_push(student_array[c].id_call)
      elsif((not(student_array[c].choice2_call.include?(":N") and (student_array[c].choice2_call.include?(":Y")))) and (student_array[c].choice2_call.delete(' ') == course_array[d].course_call.delete(' ')) and (course_array[d].seats_filled_call < course_array[d].max_seats_call) and (student_array[c].number_courses_call > 0) and (course_array[d].sections_call > 0) and (student_array[c].course_enrollment_counter_call < 1)) or (student_array[c].choice2_call.delete(' ') == course_array[d].course_call.delete(' ') + ":Y") and (course_array[d].seats_filled_call < course_array[d].max_seats_call) and (student_array[c].number_courses_call > 0) and (course_array[d].sections_call > 0) and (student_array[c].course_enrollment_counter_call < 2)
        student_array[c].course_enrollments(course_array[d].course_call.delete(' ')) and course_array[d].students_enrolled_ids_push(student_array[c].id_call)
      elsif((not(student_array[c].choice3_call.include?(":N") and (student_array[c].choice3_call.include?(":Y")))) and (student_array[c].choice3_call.delete(' ') == course_array[d].course_call.delete(' ')) and (course_array[d].seats_filled_call < course_array[d].max_seats_call) and (student_array[c].number_courses_call > 0) and (course_array[d].sections_call > 0) and (student_array[c].course_enrollment_counter_call < 1)) or (student_array[c].choice3_call.delete(' ') == course_array[d].course_call.delete(' ') + ":Y") and (course_array[d].seats_filled_call < course_array[d].max_seats_call) and (student_array[c].number_courses_call > 0) and (course_array[d].sections_call > 0) and (student_array[c].course_enrollment_counter_call < 2)
        student_array[c].course_enrollments(course_array[d].course_call.delete(' ')) and course_array[d].students_enrolled_ids_push(student_array[c].id_call)
      end
    elsif(not(student_array[c].choice1_call.nil?)) and (not(student_array[c].choice2_call.nil?))
      if((not(student_array[c].choice1_call.include?(":N") and (student_array[c].choice1_call.include?(":Y")))) and (student_array[c].choice1_call.delete(' ') == course_array[d].course_call.delete(' ')) and (course_array[d].seats_filled_call < course_array[d].max_seats_call) and (student_array[c].number_courses_call > 0) and (course_array[d].sections_call > 0) and (student_array[c].course_enrollment_counter_call < 1)) or (student_array[c].choice1_call.delete(' ') == course_array[d].course_call.delete(' ') + ":Y") and (course_array[d].seats_filled_call < course_array[d].max_seats_call) and (student_array[c].number_courses_call > 0) and (course_array[d].sections_call > 0) and (student_array[c].course_enrollment_counter_call < 2)
        student_array[c].course_enrollments(course_array[d].course_call.delete(' ')) and course_array[d].students_enrolled_ids_push(student_array[c].id_call)
      elsif((not(student_array[c].choice2_call.include?(":N") and (student_array[c].choice2_call.include?(":Y")))) and (student_array[c].choice2_call.delete(' ') == course_array[d].course_call.delete(' ')) and (course_array[d].seats_filled_call < course_array[d].max_seats_call) and (student_array[c].number_courses_call > 0) and (course_array[d].sections_call > 0) and (student_array[c].course_enrollment_counter_call < 1)) or (student_array[c].choice2_call.delete(' ') == course_array[d].course_call.delete(' ') + ":Y") and (course_array[d].seats_filled_call < course_array[d].max_seats_call) and (student_array[c].number_courses_call > 0) and (course_array[d].sections_call > 0) and (student_array[c].course_enrollment_counter_call < 2)
        student_array[c].course_enrollments(course_array[c].course_call.delete(' ')) and course_array[d].students_enrolled_ids_push(student_array[c].id_call)
      end
    elsif(not(student_array[c].choice1_call.nil?))
      if((not(student_array[c].choice1_call.include?(":N") and (student_array[c].choice1_call.include?(":Y")))) and (student_array[c].choice1_call.delete(' ') == course_array[d].course_call.delete(' ')) and (course_array[d].seats_filled_call < course_array[d].max_seats_call) and (student_array[c].number_courses_call > 0) and (course_array[d].sections_call > 0) and (student_array[c].course_enrollment_counter_call < 1)) or (student_array[c].choice1_call.delete(' ') == course_array[d].course_call.delete(' ') + ":Y") and (course_array[d].seats_filled_call < course_array[d].max_seats_call) and (student_array[c].number_courses_call > 0) and (course_array[d].sections_call > 0) and (student_array[c].course_enrollment_counter_call < 2)
        student_array[c].course_enrollments(course_array[d].course_call.delete(' ')) and course_array[d].students_enrolled_ids_push(student_array[c].id_call)
      end
    end
    d += 1
  end
  if(student_array[c].course_enrollment_counter_call < 2)
    student_array[c].enrollment_errors("The student did not get a second course or did not want one")
  end
  end
  c += 1
end

  #Output part of program
# This final part of the program writes the requisite information to the output files using the csv function and while loops


   CSV.open("students.csv", "w") do |csv| #Opens the output file
     csv << ['Paws_ID','Enrolled_Course','Errors'] #Adds the headers to the file
     l = 0
     while l < student_array.length #While loop that inputs the data for each of the students
       csv << [student_array[l].id_call, student_array[l].courses_enrolled_final, student_array[l].enrollment_errors_final]
       l += 1
     end

   end

  CSV.open("enrollment.csv", "w") do |csv| #Open the output file
    csv << ['Course_Number','Section_number','PAWS_ID','Seats_Filled','Seats_Open'] #Adds the headers to the file
    h = 0
    while h < course_array.length #While loop that goes through each course
      i = 0
      while i < course_array[h].sections_call #While loop that goes through each section of the specific course
        x = (course_array[h].students_enrolled_call/course_array[h].sections_call)
        t = (x * 7)
        j = (i * t)
        y = course_array[h].student_ids_output[j, (j + t)]
        csv << [course_array[h].course_call, i, y, x, (course_array[h].maximum_seats_call - x)] #Inputs the correct data to the csv file
        i += 1
      end
      h += 1
    end
  end



