#!/usr/bin/ruby

####################################################################
#
# CPT-104 A-2Y
# Professor:  McLeod
# Student: Ashlyn Hallman
#
# This program implements the Vending Machine Context and
# "Make Change" algorithm that returns the minimal number
# of coins.
#
####################################################################

class VendingMachine

  attr_reader :game_over

  def initialize
    @bal = 0
    @game_over = false
    @inventory =  {
      :A1 => { cost: 125, description: "Coke" },
      :A2 => { cost: 125, description: "Diet Coke" },
      :A3 => { cost: 125, description: "Mountain Dew" },
      :A4 => { cost: 275, description: "Monster Energy Drink" },
      :B1 => { cost:  75, description: "Lays Potato Chips" },
      :B2 => { cost:  60, description: "Snyder's Pretzels" },
      :B3 => { cost:  85, description: "Cool Ranch Doritos" },
      :B4 => { cost: 165, description: "Famous Amos Cookies" },
      :C1 => { cost:  45, description: "Juicy Fruit Bubblegum" },
      :C2 => { cost:  50, description: "Gummy Bears" },
      :C3 => { cost: 350, description: "Bandaids" },
      :C4 => { cost:  85, description: "Chapstick" }
    }
  end

  def menu
    puts "\e[H\e[2J\n\n-------------------------------------------"
    puts "          Ashlyn's Vending Machine"
    puts "            -- Menu of Items --"
    printf("              Balance: $ %2.2f\n", @bal.to_f/100)
    if @error
      puts "-------------------------------------------"
      @error.each_line { |line|
        printf("%43.43s\n", line.chomp)
      }
    end
    puts "-------------------------------------------"
    @inventory.each_pair { |code, product|
      printf("#{code.to_s} : %-30s $ %2.2f\n", product[:description],  product[:cost].to_f/100)
    }
    puts "-------------------------------------------"
    puts "Insert Coins & Dollars:"
    puts " 1=Nickle 2=Dime 3=Quarter 4=Dollar 5=Five"
    puts "                          q=Quit  r=Refund"
    puts "-------------------------------------------"
    print "Selection: "
    $stdout.flush

    entry = $stdin.gets.chomp
    
    @error = nil

    case entry
    when '1'; @bal += 5
    when '2'; @bal += 10
    when '3'; @bal += 25
    when '4'; @bal += 100
    when '5'; @bal += 500
    when 'q'; @game_over = true
    when 'r'; refund_balance
    else
      make_selection(entry.upcase)
    end
  end

  def refund_balance
    printf("\n\nREFUND: $ %2.2f\n", @bal.to_f/100)
    quarters_owed, dimes_owed, nickles_owed = make_change
    puts "RELEASING: #{quarters_owed} Quarters, #{dimes_owed} Dimes, #{nickles_owed} Nickles"
    @game_over = true
  end

  def make_selection(entry)
    selection = entry.to_sym

    if @inventory.has_key? selection
      coi = @inventory[selection][:cost]
      if @bal < coi
        shortage = coi - @bal
        @error = "ERROR! Not Enough Money Entered.\n#{entry} costs $ %2.2f.\nInsert $ %2.2f more." % [coi.to_f/100, shortage.to_f/100]
      else
        @bal -= coi
        puts "\n\nVENDING: '#{@inventory[selection][:description]}'"
        printf("BALANCE OWED: $ %2.2f\n", @bal.to_f/100)
        quarters_owed, dimes_owed, nickles_owed = make_change
        puts "RELEASING: #{quarters_owed} Quarters, #{dimes_owed} Dimes, #{nickles_owed} Nickles"
        @game_over = true
      end
    else
      @error = "ERROR! Selection '#{entry}' invalid."
    end
  end

  def make_change
    quarters_owed = dimes_owed = nickles_owed = 0

    loop do
      if @bal >= 25
        quarters_owed += 1
        @bal -= 25
      elsif @bal >= 10
        dimes_owed += 1
        @bal -= 10
      elsif @bal >= 5
        nickles_owed += 1
        @bal -= 5
      end
      break if @bal == 0
    end

    return quarters_owed, dimes_owed, nickles_owed
  end

end

machine = VendingMachine.new

loop do
  machine.menu 
  break if machine.game_over
end

