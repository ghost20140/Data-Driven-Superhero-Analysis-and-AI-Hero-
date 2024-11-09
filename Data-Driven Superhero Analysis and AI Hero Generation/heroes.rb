require 'json'

#
# JSON data for superheroes and their powers based on Claudio Davi's Kaggle dataset
# https://www.kaggle.com/datasets/claudiodavi/superhero-set/
#
# Mainly I converted it from CSV to JSON
#

class Array
    def tally
        inject(Hash.new(0)) { |h, x| h[x] += 1; h }
    end
end

class Hero
    attr_accessor :name, :gender, :eyecolor, :race, :haircolor, :height, :publisher, :skincolor, :alignment, :weight, :powers

    def initialize(data)
        data.each do |key, value|
            instance_variable_set("@#{key.downcase}", value) if respond_to?("#{key.downcase}=")
        end
    end

    def to_s
        return instance_variables.map { |var| "#{var} = #{instance_variable_get(var)}" }.join(',')
    end

end

def sample heroes
    # how many heroes have the power AcceleratedHealing?
    puts heroes.filter { |hero| hero.powers.include?("AcceleratedHealing") }.count

    # how many heroes have zero powers?
    puts heroes.filter { |hero| hero.powers.size == 0 }.count

    # What are the most popular and least popular superpowers
    # for superheroes with at least 1 superpower?
    superpowercount = Hash.new
    heroes.each do |hero|
        hero.powers.each do |power|
            if(!superpowercount.has_key?(power))
            superpowercount[power] = 1
            else
            superpowercount[power] += 1
            end
        end
    end
    mostpop = superpowercount.max_by{ |_,count| count}
    leastpop = superpowercount.min_by{ |_,count| count}
  puts " Most Popular Superpower #{mostpop[0]} and possesed by #{mostpop[1]} heroes"
  puts " Most Least Popular Superpower #{leastpop[0]} and possesed by #{leastpop[1]} heroes"

   # What is the average number of superpowers per superhero?

   total = heroes.map { |hero| hero.powers.size }.sum
   totalh = heroes.size
   avg = total.to_f / totalh
   puts "Average number of superpowers is #{avg}"

   #What is the average number of superpowers for superheroes
   #with at least 1 superpower?
    sup1 = heroes.filter{ |hero| hero.powers.size > 0}
    totalsup1 = sup1.map{ |hero| hero.powers.size}.sum
    puts "Average number of superpowers for superheroes with at least 1 superpower is #{totalsup1.to_f / sup1.size}"

   #What are the most popular and least popular superpowers by publisher?
    supcount = Hash.new
    heroes.each do |hero|
        comic = hero.publisher
        hero.powers.each do |power|
            if(!supcount.has_key?(comic))
                supcount[comic] = [power]
            else
                supcount[comic] << power
            end
        end
    end
    pubcount = Hash.new
    supcount.each do |pub, power|
        h = Hash.new
        power.each do |p|
            if(!h.has_key?(p))
                h[p] = 1
            else
                h[p] += 1
            end
        end
        pubcount[pub] = h
    end
    pubcount.each do |pub, power|
        puts "Publisher #{pub}"
        puts "The most popular superpower #{power.max_by{ |_,count| count}[0]} with the count #{power.max_by{ |_,count| count}[1]} and least popular superpower #{power.min_by{ |_,count| count}[0]} with the count #{power.min_by{ |_,count| count}[1]}"
        puts " "
    end

    #What is the breakdown by gender of the superheroes?
    count = Hash.new
    heroes.group_by{|hero| hero.gender}.each do |gender, hero|
        puts "#{gender} #{hero.map{|hero| hero.powers}.flatten.tally.sort_by{|k,v| v}.reverse[0]}"

    end
     #How many heroes from the Publisher Marvel Comics have heights greater than 180 centimeters?
     sup2 = heroes.filter{ |hero| hero.publisher == "Marvel Comics" && hero.height.to_i > 180}
     puts "Number of heroes from the Publisher Marvel Comics have heights greater than 180 centimeters is #{sup2.size}"

     #Compare the hero with the most superpowers from DC comics to the hero
     # with the most superpowers from Marvel Comics
        dc = heroes.filter{ |hero| hero.publisher == "DC Comics"}
        marvel = heroes.filter{ |hero| hero.publisher == "Marvel Comics"}
        dcmax = dc.max_by{|hero| hero.powers.size}
        marvelmax = marvel.max_by{|hero| hero.powers.size}
        if(dcmax.powers.size>marvelmax.powers.size)
            puts "#{dcmax.name}, the hero with the most superpowers from DC comics with #{dcmax.powers.size} superpowers has #{dcmax.powers.size - marvelmax.powers.size} more superpowers than #{marvelmax.name}, superhero with the most superpowers from Marvel comics"
        else
            puts "#{marvelmax.name}, the hero with the most superpowers from Marvel comics with #{marvelmax.powers.size} superpowers has #{marvelmax.powers.size - dcmax.powers.size} more superpowers than #{dcmax.name}, superhero with the most superpowers from DC comics"
        end

# # The new best superhero is the one with the most superpowers and height more than 180
# # and has Solar Energy Absorption as one of the superpowers
#     sup3 = heroes.filter{ |hero| hero.height.to_i > 160 && hero.powers.include?("Solar Energy Absorption")}
#     sup3max = sup3.max_by{|hero| hero.powers.size}
#     puts "#{sup3max.name} is the best hero"

# # The new worst superhero is the one with the least superpowers and weight less than 55
# sup4 = heroes.filter{ |hero| hero.weight.to_i < 55}
# sup4min = sup4.min_by{|hero| hero.powers.size}
# puts "#{sup4min.name} is the worst hero"

end

def main
    # read each row of heroes_information.csv
    heroes = Array.new
    JSON.parse(File.read("heroes.json")).each do |row|
        heroes << Hero.new(row)
    end

    # run the sample code
    sample heroes
end

if __FILE__ == $0
  main
end
