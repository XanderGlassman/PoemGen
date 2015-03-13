require 'rspec'
require './poemgen.rb'

describe 'Poem' do 
  before(:all) do 
    @word_bank = 
      "Instead of taking the short cut along the Sound we went down the road and
      entered by the big postern. With enchanting murmurs Daisy admired this
      aspect or that of the feudal silhouette against the sky, admired the
      gardens, the sparkling odor of jonquils and the frothy odor of hawthorn
      and plum blossoms and the pale gold odor of kiss-me-at-the-gate.
      It was strange to reach the marble steps and find no stir of bright
      dresses in and out the door, and hear no sound but bird voices in the
      trees.

      We went upstairs, through period bedrooms swathed in rose and lavender
      silk and vivid with new flowers, through dressing rooms and poolrooms,
      and bathrooms with sunken baths--intruding into one chamber where a
      dishevelled man in pajamas was doing liver exercises on the floor. It
      was Mr. Klipspringer, the \"boarder.\" I had seen him wandering hungrily
      about the beach that morning. Finally we came to Gatsby's own apartment,
      a bedroom and a bath and an Adam study, where we sat down and drank a
      glass of some Chartreuse he took from a cupboard in the wall.
      "

    @poem = Poem.new("the cat is a huge fatty", @word_bank)
  end
  it 'allows the user to set a model structure' do 
    expect(@poem.model_tags).to eq("det nn vbz det jj nn")
  end

  it 'allows the user to set the sentence_model structure' do 
    expect(@poem.model_full).to eq("the/DET cat/NN is/VBZ a/DET huge/JJ fatty/NN")
  end

  context 'replaces model words with bank words that are the same part of speech' do
    it 'is the right length' do 
      expect(@poem.first_gen.split.length).to eq(@poem.model_full.split.length)
    end

    it 'replaces only with words that have the right pos_structure' do 
      new_structure = EngTagger.new.get_readable(@poem.first_gen).gsub(/\w*\//, "").downcase
      expect(new_structure).to eq(@poem.model_tags)
    end
  end

  
end