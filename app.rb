TYPES = { 
  UNIPEDAL: 'Unipedal',
  BIPEDAL: 'Bipedal',
  QUADRUPEDAL: 'Quadrupedal',
  ARACHNID: 'Arachnid',
  RADIAL: 'Radial',
  AERONAUTICAL: 'Aeronautical'
}

TASKS = [
  {
    description: 'do the dishes',
    eta: 1000,
  },{
    description: 'sweep the house',
    eta: 3000,
  },{
    description: 'do the laundry',
    eta: 10000,
  },{
    description: 'take out the recycling',
    eta: 4000,
  },{
    description: 'make a sammich',
    eta: 7000,
  },{
    description: 'mow the lawn',
    eta: 20000,
  },{
    description: 'rake the leaves',
    eta: 18000,
  },{
    description: 'give the dog a bath',
    eta: 14500,
  },{
    description: 'bake some cookies',
    eta: 8000,
  },{
    description: 'wash the car',
    eta: 20000,
  },
]

ROBOTS = []

class App
  def initialize
    @running = true
  end

  def run
    welcome_message
  
    while @running
      display_options
      action = gets.chomp.to_i
      route_action(action)
    end
  end
  
  def welcome_message
    puts "\n ♫•*¨*•.¸¸♪ Welcome to Bot-o-Mat! ♫•*¨*•.¸¸♪"
    puts "\n If you need a bot, you've come to the right place!"
  end
  
  def goodbye_message
    puts "\n Thank you for using Bot-o-Mat! Come see us again for your future robot needs!"
    @running = false
  end
  
  def display_options
    sleep(0.5)
    puts "\n What would you like to do?"
    puts "\n Please enter the number that matches your request."
    puts "-----------------------------"
    puts "1. List all robots."
    puts "2. Create a new robot."
    puts "3. Assign tasks to a robot."
    puts "4. See all tasks."
    puts "5. Create a task."
    puts "6. Delete a task."
    puts "7. See a robot dance battle."
    puts "8. Leave Bot-o-Mat."
    puts "-----------------------------"
  end
  
  def route_action(action)
    # Note:
    # `action` is an integer.
    case action
    when 1 then display_robots
    when 2 then create_robot
    when 3 then assign_tasks
    when 4 then display_tasks
    when 5 then create_task
    when 6 then delete_task
    when 7 then dance_battle
    when 8 then goodbye_message
    else
      puts "\n Sorry, we can't handle that request. Please make another selection."
    end
  end
  
  def display_robots
    puts "\n Here are all our current robots."
    unless ROBOTS.empty?
      puts "-----------------------------"
      ROBOTS.each_with_index do |robot, index|
        sleep(0.3)
        puts "Robot ##{index+1}:"
        puts "- Name: #{robot.name}"
        puts "- Type: #{robot.type}"
        puts "- Score: #{robot.score}"
        puts ""
      end
      puts "-----------------------------"
    else
      puts "\n ... Oops. Looks like we don't have any robots right now. Let's create some!"
    end
  end
  
  def create_robot
    puts "\n Let's make a new robot!"
    puts "\n We can create bots of the following types:"
    puts "- Unipedal"
    puts "- Bipedal"
    puts "- Quadrupedal"
    puts "- Arachnid"
    puts "- Radial"
    puts "- Aeronautical"
    puts "\n Please tell us which type you would like."
  
    type = ask_user_for_type_for_robot_creation.capitalize
    name = ask_user_for_name_for_robot_creation.capitalize
  
    robot = Robot.new(type, name)
    ROBOTS << robot
  
    robot.celebrate_message

    puts "\n Now that your new robot has been created, let's assign them some tasks!"
  end
  
  def ask_user_for_type_for_robot_creation
    puts "\n What type of robot would you like to create?"
    type = gets.chomp
  
    validate_type(type)
  end
  
  def validate_type(input)
    # Note:
    # `input` is a string provided by the user.
    # We need to upcase and symbolize it
    # in order to find a match in TYPES.
    input_not_empty(input)
    input.class == "String"
    if TYPES[input.upcase.to_sym].nil?
      puts "\n ... Sorry, we don't have that kind of robot. Please select something else."
      input = ask_user_for_type_for_robot_creation
    end
    input
  end
  
  def ask_user_for_name_for_robot_creation
    puts "\n What is the name of your robot?"
    name = gets.chomp
  
    validate_name(name)
  end
  
  def validate_name(input)
    # Note:
    # `input` is a string provided by the user.
    # We want to make sure robots have unique names.

    puts "\n input is #{input}"

    if robot_name_exists?(input)
      puts "\n ... Sorry, looks like that name is already taken. Please choose another name."
      input = ask_user_for_name_for_robot_creation
    end
    input
  end

  def robot_name_exists?(input)
    ROBOTS.each do |robot|
      robot.name.upcase == input.upcase ? (return true) : (next)
    end
    false
  end

  def ask_user_for_name_for_task_assignment
    puts "\n Which robot would you like to assign some tasks to?"
    name = gets.chomp
  end
  
  def assign_tasks
    puts "\n Ok! Let's assign some tasks to a robot and get some work done!"
    input = ask_user_for_name_for_task_assignment
    # Note:
    # `input` is a string provided by the user.
    # It should be a robot name.
    robot = find_robot_by_name(input)
    if robot.nil?
      puts "\n Sorry, we don't have a robot with that name. Please try again."
      input = ask_user_for_name_for_task_assignment
    end
    robot.assign_tasks
    robot.complete_tasks
    display_robots
  end

  def find_robot_by_name(input)
    ROBOTS.each do |robot|
      robot.name.upcase == input.upcase ? (return robot) : (next)
    end
    nil
  end
end

def display_tasks
  puts "\n Here are all the tasks available."
  unless TASKS.empty?
    puts "-----------------------------"
    TASKS.each_with_index do |task, index|
      sleep(0.3)
      puts "Task ##{index+1}:"
      puts "- Description: #{task[:description].capitalize}"
      puts "- Duration: #{task[:eta]/1000} seconds"
      puts ""
    end
    puts "-----------------------------"
  end
end

def create_task
  puts "\n Ok, let's create a new task!"
  desc = ask_user_for_task_description
  eta = ask_user_for_task_eta

  if input_not_empty(desc) && input_not_empty(eta) && validate_task_eta(eta)
    TASKS << {
      description: desc,
      eta: eta.to_i * 1000
    }
    puts "\n Alright! The new task has been officially added to the list."
    display_tasks
  else
    puts "\n ... Sorry, we had a problem with your input. Please try again."
  end
end

def validate_task_eta(input)
  input.to_i > 0
end

def input_not_empty(input)
  if input.empty?
    puts "\n ... Sorry, we can't accept empty input. Please try again."
  else
    true
  end
end

def ask_user_for_task_description
  puts "\n Please type the description of the task."
  input = gets.chomp
end

def ask_user_for_task_eta
  puts "\n Please type the amount of seconds it should take to accomplish the task."
  input = gets.chomp
end

def delete_task
  if TASKS.empty?
    puts "\n ... Oops, looks like all the tasks have already been deleted!"
    return
  end

  puts "\n Ok, let's delete a task from the list!"
  display_tasks
  input = ask_user_for_task_description

  if delete_task_by_description(input)
    puts "\n Task successfully deleted."
    display_tasks
  else
    puts "\n ... Sorry, we don't have a task with that description. Please try again."
    delete_task
  end
end

def delete_task_by_description(input)
  TASKS.each_with_index do |task, index|
    task[:description].upcase == input.upcase ? (TASKS.delete_at(index)) : (next)
  end
end

def dance_battle
  puts "\n IT'S TIME FOR A DANCE BATTLE!"
  puts "\n First, we need to select two robots to duke it out."
  robot_one = find_robot_by_name(ask_user_for_dance_battle_name("first"))
  robot_two = find_robot_by_name(ask_user_for_dance_battle_name("second"))
  if robot_one.nil? || robot_two.nil?
    puts "\n ... Well, darn. Looks like we couldn't find one of the robots you're looking for. Please try again."
  elsif robot_one.score.zero? || robot_two.score.zero?
    puts "\n ... Well, darn. Looks like one of those robots has a score of 0 and can't battle. Please assign them some tasks to raise their score and then try again."
  else
    dance_battle_performance(robot_one, robot_two)
  end
end

def ask_user_for_dance_battle_name(order)
  # Note:
  # `order` is a string provided by the app.
  puts "\n Please enter the name of the #{order} robot you would like to have dance."
  name = gets.chomp
end

def dance_battle_performance(robot_one, robot_two)
  winner = robot_one.score > robot_two.score ? robot_one : robot_two
  puts "\n *•.¸¸ HEEEEEEERE WE GO~!!! ¸¸.•*"

  sleep(0.5)
  puts "\n #{robot_one.name}:"
  sleep(0.5)
  puts "\n ♫•*¨*•.¸¸♪"
  sleep(0.5)
  puts "\n ⁽⁽└┫￣旦￣┌┣⁾⁾"
  sleep(0.5)
  puts "\n ⁽⁽└┫￣旦￣┣┘⁾⁾"
  sleep(0.5)
  puts "\n ⁽⁽┫┐￣旦￣┣┘⁾⁾"
  sleep(0.5)
  puts "\n VERSUS"
  sleep(0.5)
  puts "\n #{robot_two.name}:"
  sleep(0.5)
  puts "\n ⁽⁽└┫● o ●┌┣⁾⁾"
  sleep(0.5)
  puts "\n ⁽⁽└┫● o ●┣┘⁾⁾"
  sleep(0.5)
  puts "\n ⁽⁽┫┐● o ●┣┘⁾⁾"
  sleep(0.5)
  puts "\n ♫•*¨*•.¸¸♪"
  sleep(0.5)

  puts "\n AND THE WINNER IS..."
  sleep(0.5)
  puts "..."
  sleep(0.5)
  puts "..."
  sleep(0.5)
  puts "..."
  sleep(0.5)
  puts "... #{winner.name} the #{winner.type} Robot!!!!!"
end

def compare_robot_scores(robot_one, robot_two)
  robot_one.score > robot_two.score
end

class Robot
  attr_accessor :type, :name, :assigned_tasks, :completed_tasks, :score
  def initialize(type, name)
    @type = type
    @name = name
    @assigned_tasks = {}
    # @completed_tasks = []
    @score = 0
  end

  def celebrate_message
    puts "\n *•.¸¸ Huzzah! #{@name} the #{@type} Robot has been created! ¸¸.•*"
  end

  def assign_tasks
    puts "\n Your robot has been assigned the following tasks:"
    TASKS.sample(5).each_with_index do |task, index|
      @assigned_tasks[index+1] = task
      puts "- #{task[:description].capitalize}"
    end
  end

  def complete_tasks
    puts "\n #{@name} the #{@type} Robot will now begin the assigned tasks."

    @assigned_tasks.each do |task|
      # Note: 
      # `task` is an array of the following structure:
      # [key, value]
      # key: the assigned index from assign_tasks method
      # value: the task object sampled from assign_tasks method

      puts "\n #{@name} the #{@type} Robot: Beginning task '#{task[1][:description]}' now..."
      sleep(task[1][:eta]/1000)
      @score += task[1][:eta]
      @assigned_tasks.delete(task[0])
      # Note:
      # Since `task` is an array in this loop,
      # we know the 0th place is the assigned index in @tasks,
      # and that is what we need to target to remove the task
      # and modify @assigned_tasks successfully.

      # @completed_tasks << task[1]

      puts " ... Task completed."
      next
    end

    @assigned_tasks.empty? ? (puts "\n All tasks completed.") : (puts "Error!")
  end
end

app = App.new

app.run