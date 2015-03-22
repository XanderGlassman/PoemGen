require "rspec"
require "./poemgen.rb"

# TODO put car poem in the before all block
describe "Poem" do 

  before(:all) do 
    @word_bank = 
      "
      We went upstairs, through period bedrooms swathed in rose and lavender
      silk and vivid with new flowers, through dressing rooms and poolrooms,
      and bathrooms with sunken baths--intruding into one chamber where a
      dishevelled man in pajamas was doing liver exercises on the floor. It
      was Mr. Klipspringer, the \"boarder.\" I had seen him wandering hungrily
      about the beach that morning. Finally we came to Gatsby's own apartment,
      a bedroom and a bath and an Adam study, where we sat down and drank a
      glass of some Chartreuse he took from a cupboard in the wall.
      "
    @poem = Poem.new("The cat is a huge fatty", @word_bank)
    @car_poem = Poem.new("the car is cool", "the flower is nice")
  end

  def get_structure(full_text)
    EngTagger.new.get_readable(full_text).gsub(/\w*\//, "").downcase
  end

  context "poem attributes" do 
    it "allows the user to set a model structure" do 
      expect(@poem.model_tags).to eq("det nn vbz det jj nn")
    end

    it "allows the user to see the model sentence" do 
      expect(@poem.model_sentence).to eq("The cat is a huge fatty")
    end  

    it "sets the model sentence as the first poem" do 
      expect(@poem.poem).to eq("The cat is a huge fatty")
    end
  end

  context "#find_word" do 
    before(:all) do 
      @new_word = @poem.find_word("nn")
    end

    it "returns a word different from the model" do 
      expect(@new_word).to_not eq("cat")
      expect(@new_word).to_not eq("fatty")
    end

    it "new word has requested pos" do 
      expect(get_structure(@poem.find_word("nn"))).to eq("nn")
    end

    it "errors out when the requsted pos is not in the word bank" do 
      poem = Poem.new("the cat is not nice", "the cat is nice")
      expect{poem.find_word("rs")}.to raise_error(RuntimeError, "rs part of speech not in word bank")
    end
  end 

  context "#generate_poem" do
    before(:all) do 
      @generated_poem = @poem.generate_poem
    end

    it "is the right size" do 
      expect(@generated_poem.split.size).to eq(@poem.model_sentence.split.size)
    end

    it "returns strucutrally same sentence" do 
      expect(get_structure(@generated_poem)).to eq(@poem.model_tags)
    end
# 
    it "the generated_poem is different from model" do 
      expect(@generated_poem).to_not eq(@poem.model_sentence)
    end
  end

  context "#next_generation" do 
    before(:all) do 
      @next_generation = @poem.next_generation
    end

    it "returns an array of five new poems" do 
      expect(@next_generation.size).to eq(6)
    end

    it "each poem has the right structure" do 
      expect(@next_generation
        .all?{|new_poem| get_structure(new_poem) == @poem.model_tags})
          .to be_truthy
    end
  end

  context "#print_generations(gen)" do 
    it "prints each generation with a number in front" do 
      expect {@car_poem.print_generations(@car_poem.next_generation)}.to output(
          "\"1(parent) The car is cool\"\n"\
          "\"2 The flower is nice\"\n\"3 The flower is nice\"\n\"4 The flower is nice\"\n"\
          "\"5 The flower is nice\"\n\"6 The flower is nice\"\n"
        ).to_stdout  
    end
  end

  context "#select_poem" do
    before(:all) do 
      @next_generation = @car_poem.next_generation
    end

    it "sets the poem when the choice is appropriate" do 
      expect(@car_poem.poem).to eq("The car is cool")
      allow(STDIN).to receive(:gets) {"6"}
      @car_poem.select_poem(@next_generation)
      expect(@car_poem.poem).to eq("The flower is nice")
    end

    it "errors when the choice is not 1-5" do
      allow(STDIN).to receive(:gets) {"7"}
      expect{@car_poem.select_poem(@next_generation)}
      .to raise_error(
        RuntimeError, "must enter the number of the poem you would like to mutate (1 to 5)"
      )
    end

    it "errors when the choice is not an integer" do
      allow(STDIN).to receive(:gets) {"first"}
      expect{@car_poem.select_poem(@next_generation)}.to raise_error(
        RuntimeError, "must enter the number of the poem you would like to mutate (1 to 5)"
      )
    end

    it "allows an exit" do 
      expect{@poem.allow_exit("exit")}.to raise_error(
        SystemExit, "your poem is \"The cat is a huge fatty\"")
    end
  end

  context "mutate_poem(mutation_rate)" do
    it "does not change if mutation rate is 0" do
      expect(@poem.mutate_poem(0)).to eq(@poem.poem)
    end 

    it "does change if mutation rate is 100" do 
      expect(@poem.mutate_poem(100)).to_not eq(@poem.poem)
    end 

    it "has the right structure" do 
      expect(get_structure(@poem.mutate_poem(100))).to eq(get_structure(@poem.poem))  
    end
  end

  context "#validate_mutation_rate(provided_rate)" do 
    it "returns the rate when it is within parameters" do 
      expect(@poem.validate_mutation_rate("20")).to eq(20)
    end

    it "errors when input is not a number" do 
      expect{@poem.validate_mutation_rate("Gatsby!")}.to raise_error(
        RuntimeError, "mutation rate must be a number"
      )
    end

    it "errors when input is not in range" do 
      expect{@poem.validate_mutation_rate("101")}.to raise_error(
        RuntimeError, "mutation rate must be between 0 and 100"
      )
    end

    it "allows an exit" do 
      expect{@poem.validate_mutation_rate("exit")}.to raise_error(
        SystemExit, "your poem is \"The cat is a huge fatty\"")
    end
  end

  context "#evolve(mutation_rate) creates new genration and updates the poem" do 
    before(:each) do 
      @car_poem = Poem.new("the car is cool", "the flower is nice")
    end

    it 'sets new poem when mutation rate is 100' do 
      allow(STDIN).to receive(:gets) {"4"}
      @car_poem.evolve(100)
      expect(@car_poem.poem).to eq('The flower is nice')
    end

    it 'sets old poem when mutation rate is 0' do 
      allow(STDIN).to receive(:gets) {"4"}
      @car_poem.evolve(0)
      expect(@car_poem.poem).to eq('The car is cool')
    end
  end

  context "#allow_exit" do 
    it "allows an exit" do 
      expect{@poem.allow_exit("exit")}.to raise_error(
        SystemExit, "your poem is \"The cat is a huge fatty\"")
    end
  end

end